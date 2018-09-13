# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class Engine < ::Rails::Engine
      isolate_namespace Hyrax::ActiveEncode

      initializer "hyrax.active_encode.prepend_derivative_service" do
        Hyrax::DerivativeService.services = [Hyrax::ActiveEncode::ActiveEncodeDerivativeService] + Hyrax::DerivativeService.services
      end
    end
  end
end
