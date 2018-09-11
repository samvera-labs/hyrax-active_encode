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

      def files_metadata
        files.collect { |f| { id: f.id, label: f.label.first, external_file_uri: f.external_file_uri.first } }
      end
    end
  end
end
