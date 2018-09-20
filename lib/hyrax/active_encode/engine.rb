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
        Hydra::Derivatives.output_file_service = Hyrax::ActiveEncode::PersistActiveEncodeDerivatives
      end
    end
  end
end
