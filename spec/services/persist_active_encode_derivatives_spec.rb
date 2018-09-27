# frozen_string_literal: true
require 'rails_helper'
require 'tempfile'

describe Hyrax::ActiveEncode::PersistActiveEncodeDerivatives do
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

  let(:url) { 'testurl' }
  let(:label) { 'high' }
  let(:directory) { nil }

  let(:file_set) { ActiveEncodeFileSet.create }
  let(:derivative) do
    file_set.build_derivative.tap do |d|
      d.label = label
      d.external_file_uri = url
      d.content = ''
    end
  end

  let(:directives) { { derivative_directory: directory, file_set_id: file_set.id } }
  let(:output) do
    ActiveEncode::Output.new.tap do |o|
      o.url = url
      o.label = label
    end
  end
  let(:service) { described_class.new }

  describe '#call' do
    subject { service.call(output, directives) }

    context 'with a specified derivative_directory' do
      let(:directory) { '/derivatives/' }
      let(:filename) { 'test_high.mp4' }
      let(:file_path) { directory + filename }

      context 'with a local output file' do
        let(:file) { Tempfile.new(filename) }
        let(:url) { 'file://' + file.path }

        it 'moves the output file to the specified derivative_directory' do
          # expect(FileUtils).to have_received(:mv).with('/outputs/test_high.mp4', '/derivatives/test_high.mp4')
          expect(File.exist?(file_path)).to eq true
          expect(file.exist?).to eq false
        end

        it 'updates the output url to point to the specified derivative_directory' do
          expect(output.url).to eq 'file://' + file_path
        end
      end

      context 'with an external output file' do
        let(:host) { 'http://example.com/outputs/' }
        let(:url) { host + filename }

        before do
          stub_request(:get, url).to_return(status: 200, body: "", headers: {})
        end

        it 'copies the output file to the specified derivative_directory' do
          # expect(IO).to have_received(:copy_stream).with('/outputs/test_high.mp4', '/derivatives/test_high.mp4')
          expect(File.exist?(file_path)).to eq true
        end

        it 'updates the output url to point to the specified derivative_directory' do
          expect(output.url).to eq 'file://' + file_path
        end
      end
    end

    context 'when derivative_directory is not specified' do
      it 'the output url is not changed' do
        expect(output.url).to eq url
      end
    end

    let(:pcdm_file) { expect(file_set.reload.derivatives)[0] }

    it "creates pcdm file" do
      expect(pcdm_file.label).to eq label
      expect(pcdm_file.external_file_uri).to eq url
      expect(pcdm_file.contect).to eq ''
    end
  end
end
