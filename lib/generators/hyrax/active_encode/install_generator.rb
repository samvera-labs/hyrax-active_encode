# frozen_string_literal: true
require 'rails/generators'

module Hyrax
  module ActiveEncode
    class InstallGenerator < Rails::Generators::Base
      source_root "../templates"

      def enhance_file_set
        # This module include has to come before Hyrax::FileSetBehavior since it finalizes properties
        insert_into_file 'app/models/file_set.rb', before: 'include ::Hyrax::FileSetBehavior' do
          "include Hyrax::ActiveEncode::FileSetBehavior\n  "
        end
        # The indexer has to be set after Hyrax::FileSetBehavior in order to have effect
        insert_into_file 'app/models/file_set.rb', after: 'include ::Hyrax::FileSetBehavior' do
          "\n  self.indexer = Hyrax::ActiveEncode::ActiveEncodeIndexer"
        end
      end

      def install_active_encode
        rake 'active_encode:install:migrations'
        rake 'db:migrate'
      end

      def install_migrations
        rake 'hyrax_active_encode:install:migrations'
      end

      def insert_abilities
        insert_into_file 'app/models/ability.rb', after: /Hyrax::Ability/ do
          "\n  include Hyrax::ActiveEncode::Ability\n"
        end
      end
    end
  end
end
