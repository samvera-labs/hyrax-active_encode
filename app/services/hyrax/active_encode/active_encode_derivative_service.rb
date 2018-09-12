# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class ActiveEncodeDerivativeService < Hyrax::DerivativeService
      # Is this the right place for this line?
      # Hyrax::DerivativeService.services = [Hyrax::ActiveEncode::ActiveEncodeDerivativeService] + Hyrax::DerivativeService.services

      def initialize(file_set)
        @file_set = file_set
      end

      # TODO: Implement this?
      def cleanup_derivatives; end

      def create_derivatives(filename)
        # TODO: Pass encode class from configuration and other output configuration (preset?)
        job_settings = []
        Hydra::Derivatives::ActiveEncodeDerivatives.create(filename, outputs: [job_settings])
      end

      # What should this return?
      def derivative_url(file_label)
        derivative = file_set.derivatives.find { |d| d.label.first == file_label }
        derivative.nil? ? nil : derivative.external_file_uri.first
      end

      def valid?
        supported_mime_types.include?(mime_type)
      end

      private

        def supported_mime_types
          file_set.class.audio_mime_types + file_set.class.video_mime_types
        end
    end
  end
end
