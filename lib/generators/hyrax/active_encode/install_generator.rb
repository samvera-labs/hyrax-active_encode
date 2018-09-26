# frozen_string_literal: true
require 'rails/generators'

module Hyrax
  module ActiveEncode
    class InstallGenerator < Rails::Generators::Base
      source_root "../templates"

      def enhance_file_set
        insert_into_file 'app/models/file_set.rb', after: 'include ::Hyrax::FileSetBehavior' do
          "\n" \
          "  include Hyrax::ActiveEncode::FileSetBehavior\n" \
          "  self.indexer = Hyrax::ActiveEncode::ActiveEncodeIndexer"
        end
      end
    end
  end
end
