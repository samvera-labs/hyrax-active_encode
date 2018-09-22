# frozen_string_literal: true
require 'active_encode'

module Hyrax
  module ActiveEncode
    class ActiveEncodeDerivativeService < Hyrax::DerivativeService
      attr_accessor :encode_class, :options_service_class

      def initialize(file_set, encode_class: ::ActiveEncode::Base, options_service_class: DefaultOptionService, local_streaming: true)
        super(file_set)
        @encode_class = encode_class
        @options_service_class = options_service_class
        @local_streaming = local_streaming
      end

      def create_derivatives(filename)
        byebug
        options = options_service_class.call(@file_set)
        options.each do |option|
          option[:file_set_id] = file_set.id
          option[:derivative_directory] = derivative_directory if local_streaming?
        end
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

      def local_streaming?
        @local_streaming == true
      end

      private

        def derivative_directory
          pair_path = file_set.id.split('').each_slice(2).map(&:join).join('/')
          Pathname.new(Hyrax.config.derivatives_path).join(pair_path).to_s
        end

        def supported_mime_types
          file_set.class.audio_mime_types + file_set.class.video_mime_types
        end
    end
  end
end
