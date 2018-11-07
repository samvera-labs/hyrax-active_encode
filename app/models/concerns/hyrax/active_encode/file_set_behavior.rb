# frozen_string_literal: true
require 'active_fedora/with_metadata/file_location_uri_schema'

module Hyrax
  module ActiveEncode
    module FileSetBehavior
      extend ActiveSupport::Concern

      included do
        # Is this too late?  Has the ActiveFedora::File metadata schema been frozen already?
        ActiveFedora::WithMetadata::DefaultMetadataClassFactory.file_metadata_schemas += [ActiveFedora::WithMetadata::ExternalFileUriSchema]

        # The following doesn't work because through isn't allowed on directly_contains even though it is on directly_contains_one
        # directly_contains :derivatives, through: :files, type: ::RDF::URI('http://pcdm.org/use#ServiceFile'), class_name: 'Hydra::PCDM::File'
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
