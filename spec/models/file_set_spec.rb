# frozen_string_literal: true
require 'rails_helper'

describe FileSet do
  let(:file_set) { described_class.create }
  let(:derivative) do
    file_set.build_derivative.tap do |d|
      d.label = 'high'
      d.file_location_uri = 'http://test.file'
      d.content = ''
    end
  end

  describe '#build_derivative' do
    it 'returns a PCDM service file' do
      expect(file_set.build_derivative.metadata_node.type).to include(::RDF::URI('http://pcdm.org/use#ServiceFile'))
    end

    it 'adds it to the file set' do
      expect { file_set.build_derivative }.to change { file_set.files.size }.from(0).to(1)
    end

    it 'persists correctly' do
      expect(derivative).not_to be_persisted
      file_set.save
      expect(derivative).to be_persisted
      expect(file_set.reload.derivatives).to include derivative
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
    let(:derivatives_metadata) { [{ id: derivative.id, label: 'high', file_location_uri: 'http://test.file' }] }
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
