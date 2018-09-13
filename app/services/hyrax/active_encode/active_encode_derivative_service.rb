# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class ActiveEncodeDerivativeService < Hyrax::DerivativeService
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
        supported_mime_types.include?(file_set.mime_type)
      end

      # TODO: Implement this?
      def cleanup_derivatives; end

      private

        def supported_mime_types
          file_set.class.audio_mime_types + file_set.class.video_mime_types
        end
    end
  end
end
