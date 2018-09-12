# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    module IndexesFileMetadata
      def generate_solr_document
        super.tap do |solr_doc|
          solr_doc['derivatives_metadata_ssi'] = object.derivatives_metadata.to_json
        end
      end
    end
  end
end
