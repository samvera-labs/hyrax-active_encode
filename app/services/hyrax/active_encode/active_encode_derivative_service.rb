# frozen_string_literal: true
require 'active_encode'

module Hyrax
  module ActiveEncode
    class ActiveEncodeDerivativeService < Hyrax::DerivativeService
      attr_accessor :encode_class, :options_service_class

      def initialize(file_set, encode_class: ::ActiveEncode::Base, options_service_class: nil)
        super(file_set)
        @encode_class = encode_class
        @options_service_class = options_service_class
      end

      def create_derivatives(filename)
        options = options_service_class.call(@file_set) if options_service_class
        options ||= default_outputs(@file_set)
        Hydra::Derivatives::ActiveEncodeDerivatives.create(filename, outputs: options, encode_class: @encode_class)
      end

      # What should this return?
      def derivative_url(file_label)
        derivative = file_set.derivatives.find { |d| d.label.first == file_label }
        derivative.nil? ? nil : derivative.external_file_uri.first
      end

      def valid?
        supported_mime_types.include?(file_set.mime_type) && file_set.class.include?(Hyrax::ActiveEncode::FileSetBehavior)
      end

      # TODO: Implement this?
      def cleanup_derivatives; end

      private

        def supported_mime_types
          file_set.class.audio_mime_types + file_set.class.video_mime_types
        end

        def default_outputs(file_set)
          # Defaults adapted from hydra-derivatives
          audio_encoder = Hydra::Derivatives::AudioEncoder.new
          case file_set
          when file_set.audio?
            [{ label: 'mp4', ffmpeg_opt: "320x240 -ac 2 -ab 96k -ar 44100 -acodec #{audio_encoder.audio_encoder}" }]
          when file_set.video?
            [{ label: 'mp4', ffmpeg_opt: "320x240 -g 30 -b:v 345k -ac 2 -ab 96k -ar 44100 -vcodec libx264 -acodec #{audio_encoder.audio_encoder}" }]
          else
            []
          end
        end
    end
  end
end
