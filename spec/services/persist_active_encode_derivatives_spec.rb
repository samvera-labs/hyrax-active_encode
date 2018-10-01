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
  let(:file_set) { ActiveEncodeFileSet.create }
  let(:derivative) do
    file_set.build_derivative.tap do |d|
      d.label = label
      d.external_file_uri = url
      d.content = ''
    end
  end

  let(:local_streaming) { true }
  let(:directives) { { local_streaming: local_streaming, file_set_id: file_set.id } }
  let(:output) do
    ActiveEncode::Output.new.tap do |o|
      o.url = url
      o.label = label
    end
  end


  describe '#call' do
    subject { Hyrax::ActiveEncode::PersistActiveEncodeDerivatives.call(output, directives) }

    context 'for local streaming' do
      let(:filename) { 'sample.mp4' }
      let(:refpath) { Hyrax::DerivativePath.derivative_path_for_reference(file_set.id, filename) }
      let(:downpath) { Hyrax::Engine.routes.url_helpers.download_path(file_set, file: filename) }

      context 'with a local output derivative' do
        let(:file) { Tempfile.new() }
        let(:filename) { File.basename(file) }
        let(:url) { 'file://' + file.path }

        it 'moves the derivative to the designated reference directory' do
          subject
          expect(File.exist?(refpath)).to eq true
          # expect(File.exist?(file)).to eq false
        end
      end

      context 'with an external output derivative' do
        let(:host) { 'http://example.com/outputs/' }
        let(:url) { host + filename }

        before do
          stub_request(:get, url).to_return(status: 200, body: "", headers: {})
        end

        it 'copies the derivative to the designated reference directory' do
          subject
          expect(File.exist?(refpath)).to eq true
        end
      end

      it 'updates the output url to point to the designated download directory' do
        subject
        expect(output.url).to eq downpath
      end
    end

    context 'for remote streaming' do
      let(:local_streaming) { false }

      it 'the output url is not changed' do
        subject
        expect(output.url).to eq url
      end
    end

    let(:pcdm_file) { file_set.reload.derivatives.first }
    it "creates pcdm file" do
      subject
      expect(pcdm_file.label).to eq label
      expect(pcdm_file.external_file_uri).to eq url
      expect(pcdm_file.contect).to eq ''
    end
  end
end
