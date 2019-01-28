# frozen_string_literal: true
require 'rails_helper'
require 'tempfile'

describe Hyrax::ActiveEncode::PersistActiveEncodeDerivatives do
  let(:url) { 'testurl' }
  let(:label) { 'high' }
  let(:file_set) { FileSet.create }
  let(:pcdm_file) { file_set.reload.derivatives.first }
  let(:derivative) do
    file_set.build_derivative.tap do |d|
      d.label = label
      d.file_location_uri = url
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
    subject(:call_persist) { described_class.call(output, directives) }

    context 'for local streaming' do
      let(:filename) { 'sample.mp4' }
      let(:refpath) { Hyrax::DerivativePath.derivative_path_for_reference(file_set.id, filename) }

      context 'with a local output derivative' do
        let(:file) { Tempfile.new }
        let(:filename) { File.basename(file) }
        let(:url) { 'file://' + file.path }

        it 'moves the derivative to the designated reference directory' do
          call_persist
          expect(File.exist?(refpath)).to eq true
          # expect(File.exist?(file)).to eq false
        end

        it 'updates the output url to point to the designated download directory' do
          call_persist
          expect(output.url).to eq refpath
        end

        it "creates pcdm file" do
          call_persist
          expect(pcdm_file.label).to eq Array[label]
          expect(pcdm_file.file_location_uri).to eq Array[refpath]
          expect(pcdm_file.content).to eq ''
        end
      end

      context 'with an external output derivative' do
        let(:host) { 'http://example.com/outputs/' }
        let(:url) { host + filename }

        before do
          stub_request(:get, url).to_return(status: 200, body: "", headers: {})
        end

        it 'copies the derivative to the designated reference directory' do
          call_persist
          expect(File.exist?(refpath)).to eq true
        end

        it 'updates the output url to point to the designated download directory' do
          call_persist
          expect(output.url).to eq refpath
        end

        it "creates pcdm file" do
          call_persist
          expect(pcdm_file.label).to eq Array[label]
          expect(pcdm_file.file_location_uri).to eq Array[refpath]
          expect(pcdm_file.content).to eq ''
        end
      end
    end

    context 'for remote streaming' do
      let(:local_streaming) { false }

      it 'the output url is not changed' do
        call_persist
        expect(output.url).to eq url
      end

      it "creates pcdm file" do
        call_persist
        expect(pcdm_file.label).to eq Array[label]
        expect(pcdm_file.file_location_uri).to eq Array[url]
        expect(pcdm_file.content).to eq ''
      end
    end
  end
end
