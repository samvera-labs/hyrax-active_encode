# frozen_string_literal: true
# These are the default properties defined on a resource that has WithMetadata
# added to it. This is most commonly used with ActiveFedora::File, when we want
# to add rdf triples to a non-rdf resource and have them persisted.
module ActiveFedora::WithMetadata
  class FileLocationUriSchema < ActiveTriples::Schema
    # Don't cast to keep values as RDF::URI instead of RDF::Resource
    property :file_location_uri, predicate: ::RDF::Vocab::EBUCore.locator, cast: false do |index|
      index.as :stored_searchable
    end
  end
end
