# frozen_string_literal: true
require 'active_fedora/with_metadata/external_file_uri_schema'

module Hyrax
  module ActiveEncode
    module FileSetBehavior
      extend ActiveSupport::Concern

      included do
        # Is this too late?  Has the ActiveFedora::File metadata schema been frozen already?
        ActiveFedora::WithMetadata::DefaultMetadataClassFactory.file_metadata_schemas += [ActiveFedora::WithMetadata::ExternalFileUriSchema]
      end

      def build_derivative
        derivative = Hydra::PCDM::File.new
        derivative.metadata_node.type << ::RDF::URI('http://pcdm.org/use#ServiceFile')
        files << derivative
        derivative
      end

      def derivatives
        filter_files_by_type(::RDF::URI('http://pcdm.org/use#ServiceFile'))
      end

      def derivatives_metadata
        derivatives.collect { |f| { id: f.id, label: f.label.first, external_file_uri: f.external_file_uri.first } }
      end
    end
  end
end
