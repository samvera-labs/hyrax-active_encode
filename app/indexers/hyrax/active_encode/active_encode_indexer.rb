# frozen_string_literal: true

module Hyrax
  module ActiveEncode
    class ActiveEncodeIndexer < Hyrax::FileSetIndexer
      include Hyrax::ActiveEncode::IndexesFileMetadata
    end
  end
end
