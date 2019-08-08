# frozen_string_literal: true
require 'active_encode'

module Hyrax
  module ActiveEncode
    class Engine < ::Rails::Engine
      isolate_namespace Hyrax::ActiveEncode

      initializer "hyrax.active_encode.prepend_derivative_service" do
        Hyrax::DerivativeService.services = [Hyrax::ActiveEncode::ActiveEncodeDerivativeService] + Hyrax::DerivativeService.services
      end

      initializer "hyrax.active_encode.ffmpeg_adapter" do
        ::ActiveEncode::Base.engine_adapter = :ffmpeg
      end

      initializer "hyrax.active_encode.output_service" do
        Hydra::Derivatives::ActiveEncodeDerivatives.output_file_service = Hyrax::ActiveEncode::PersistActiveEncodeDerivatives
      end

      initializer "hyrax.active_encode.dashboard_sidebar_link" do
        # We need to explicitly require hyrax/search_state in Hyrax < 3
        # This was fixed in https://github.com/samvera/hyrax/pull/3686
        require 'hyrax/search_state'

        # Workaround issue with Hyrax and engine_cart generation
        ::ApplicationController.class_eval { include Hyrax::ThemedLayoutController } unless ::ApplicationController.include? Hyrax::ThemedLayoutController

        unless Hyrax::DashboardController.respond_to? :sidebar_partials
          Hyrax::DashboardController.class_eval do
            class_attribute :sidebar_partials
            self.sidebar_partials = {}
          end
        end

        Hyrax::DashboardController.sidebar_partials[:repository_content] ||= []
        Hyrax::DashboardController.sidebar_partials[:repository_content] += ['hyrax/dashboard/sidebar/transcoding_jobs']
      end
    end
  end
end
