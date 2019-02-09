# frozen_string_literal: true
require 'active_encode'

module Hyrax
  module ActiveEncode
    class ActiveEncodeDerivativeService < Hyrax::DerivativeService
      class << self
        def default_encode_class=(klass)
          @@default_encode_class = klass
        end

        def default_encode_class
          @@default_encode_class ||= ::ActiveEncode::Base
        end

        def default_options_service_class=(klass)
          @@default_options_service_class = klass
        end

        def default_options_service_class
          @@default_options_service_class ||= Hyrax::ActiveEncode::DefaultOptionService
        end

        def default_local_streaming=(local_streaming)
          @@default_local_streaming = local_streaming
        end

        def default_local_streaming
          @@default_local_streaming = true unless defined?(@@default_local_streaming)
          @@default_local_streaming
        end
      end

      attr_accessor :encode_class, :options_service_class

      def initialize(file_set, encode_class: self.class.default_encode_class, options_service_class: self.class.default_options_service_class, local_streaming: self.class.default_local_streaming)
        super(file_set)
        @encode_class = encode_class
        @options_service_class = options_service_class
        @local_streaming = local_streaming
      end

      def create_derivatives(filename)
        options = options_service_class.call(@file_set)
        options.each do |option|
          option[:file_set_id] = file_set.id
          option[:local_streaming] = true if local_streaming?
        end
        Hydra::Derivatives::ActiveEncodeDerivatives.create(filename, outputs: options, encode_class: @encode_class)
      end

      # What should this return?
      def derivative_url(file_label)
        derivative = file_set.derivatives.find { |d| d.label.first == file_label }
        derivative.nil? ? nil : derivative.file_location_uri.first
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

        def supported_mime_types
          file_set.class.audio_mime_types + file_set.class.video_mime_types
        end
    end
  end
end
