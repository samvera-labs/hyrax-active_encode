# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  before(:all) do
    class ActiveEncodeIndexer < ActiveFedora::IndexingService
      include Hyrax::ActiveEncode::IndexesFileMetadata
    end

    class ActiveEncodeFileSet < ::FileSet
      include Hyrax::ActiveEncode::FileSetBehavior
      self.indexer = ActiveEncodeIndexer
    end
  end

  after(:all) do
    Object.send(:remove_const, :ActiveEncodeIndexer)
    Object.send(:remove_const, :ActiveEncodeFileSet)
  end

  describe '#files_metadata' do
    let(:file_set) { ActiveEncodeFileSet.new }
    let(:file_1) { Hydra::PCDM::File.new }
    let(:file_metadata) { [{ id: 'an_id', label: 'high', external_file_uri: 'http://test.file' }] }
    let(:indexer) { file_set.class.indexer.new(file_set) }

    context 'when derivative files are present' do
      before do
        file_1.label = 'high'
        file_1.external_file_uri = 'http://test.file'
        file_set.files << file_1
        # Set the ID here after the metadata_node has been initialized to avoid a call to fedora
        file_1.id = 'an_id'
      end

      it 'responds to files_metadata' do
        expect(file_set.files_metadata).to eq(file_metadata)
      end

      it 'responds to to_solr' do
        expect(indexer.generate_solr_document['files_metadata_ssi']).to eq(file_metadata.to_json)
      end
    end
  end
end
