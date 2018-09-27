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

  let(:file_set) { ActiveEncodeFileSet.new }
  let(:derivative) do
    file_set.build_derivative.tap do |d|
      d.id = 'an_id'
      d.label = 'high'
      d.external_file_uri = 'http://test.file'
    end
  end

  describe '#build_derivative' do
    it 'returns a PCDM service file' do
      expect(derivative.metadata_node.type).to include(::RDF::URI('http://pcdm.org/use#ServiceFile'))
    end

    it 'adds it to the file set' do
      expect { file_set.build_derivative }.to change { file_set.files.size }.from(0).to(1)
    end
  end

  describe '#derivatives' do
    let(:other_file) { Hydra::PCDM::File.new }

    before do
      derivative
      file_set.files << other_file
    end

    it 'returns only PCDM service files' do
      expect(file_set.derivatives).to be_a Array
      expect(file_set.derivatives).to include(derivative)
      expect(file_set.derivatives).not_to include(other_file)
    end
  end

  describe '#derivatives_metadata' do
    let(:file_set) { ActiveEncodeFileSet.new }
    let(:derivatives_metadata) { [{ id: 'an_id', label: 'high', external_file_uri: 'http://test.file' }] }
    let(:indexer) { file_set.class.indexer.new(file_set) }

    before do
      derivative
    end

    context 'when derivative files are present' do
      it 'responds to derivatives_metadata' do
        expect(file_set.derivatives_metadata).to eq(derivatives_metadata)
      end

      it 'responds to to_solr' do
        expect(indexer.generate_solr_document['derivatives_metadata_ssi']).to eq(derivatives_metadata.to_json)
      end
    end
  end
end
