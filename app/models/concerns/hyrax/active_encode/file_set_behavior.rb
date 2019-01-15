# frozen_string_literal: true
require 'active_fedora/with_metadata/file_location_uri_schema'

module Hyrax
  module ActiveEncode
    module FileSetBehavior
      extend ActiveSupport::Concern

      included do
        property :encode_global_id, predicate: ::RDF::URI.new('http://avalonmediasystem.org/rdf/vocab/transcoding#workflowId'), multiple: false do |index|
          index.as :symbol
        end

        ActiveFedora::WithMetadata::DefaultMetadataClassFactory.file_metadata_schemas += [ActiveFedora::WithMetadata::FileLocationUriSchema]
      end

      def build_derivative
        # This only works when the file_set has already been saved
        files.build.tap do |file|
          file.metadata_node.type << ::RDF::URI('http://pcdm.org/use#ServiceFile')
        end
      end

      def derivatives
        filter_files_by_type(::RDF::URI('http://pcdm.org/use#ServiceFile'))
      end

      def derivatives_metadata
        derivatives.collect { |f| { id: f.id, label: f.label.first, file_location_uri: f.file_location_uri.first } }
      end
    end
  end
end
