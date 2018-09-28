# frozen_string_literal: true

require 'rails_helper'
require 'hyrax/specs/shared_specs'

describe Hyrax::ActiveEncode::ActiveEncodeDerivativeService do
  before(:all) do
    class ActiveEncodeFileSet < ::FileSet
      include Hyrax::ActiveEncode::FileSetBehavior
    end

    class CustomOptionService
      def self.call(_file_set)
        [{ foo: 'bar' }]
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :ActiveEncodeFileSet)
    Object.send(:remove_const, :CustomOptionService)
  end

  let(:valid_file_set) { ActiveEncodeFileSet.new }
  let(:valid_mime) { service.send(:supported_mime_types).sample }

  before do
    allow(valid_file_set).to receive(:mime_type).and_return(valid_mime)
  end

  let(:file_set) { ActiveEncodeFileSet.create }
  let(:encode_class) { ::ActiveEncode::Base }
  let(:options_service_class) { Hyrax::ActiveEncode::DefaultOptionService }
  let(:service) { described_class.new(file_set, encode_class: encode_class, options_service_class: options_service_class) }

  it_behaves_like "a Hyrax::DerivativeService"

  describe '#valid?' do
    subject { service.valid? }

    context 'all supported mime types' do
      let(:supported_mime_types) { service.send(:supported_mime_types) }

      it 'supports expected mime types' do
        supported_mime_types.each do |mime|
          file_set = ActiveEncodeFileSet.new
          allow(file_set).to receive(:mime_type).and_return(mime)
          expect(described_class.new(file_set).valid?).to be true
        end
      end
    end

    context 'with video original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('video/mp4')
      end

      it { is_expected.to be true }
    end

    context 'with audio original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('audio/wav')
      end

      it { is_expected.to be true }
    end

    context 'with non-AV original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('application/pdf')
      end

      it { is_expected.to be false }
    end
  end

  describe '#create_derivatives' do
    let(:options) { options_service_class.call(file_set) }
    let(:outputs) { options.map { |o| o.merge(internal_options) } }
    let(:derivative_url) { service.send(:derivative_url, 'high') }

    context 'with local streaming' do
      let(:internal_options) { { file_set_id: file_set.id, local_streaming: true } }

      it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
        allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        service.create_derivatives("sample.mp4")
        expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
      end

      context 'with custom options service class' do
        let(:options_service_class) { CustomOptionService }

        it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
          allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
          service.create_derivatives("sample.mp4")
          expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        end
      end
    end

    context 'with external streaming' do
      let(:service) { described_class.new(file_set, encode_class: encode_class, options_service_class: options_service_class, local_streaming: false) }
      let(:internal_options) { { file_set_id: file_set.id } }

      it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
        allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        service.create_derivatives("sample.mp4")
        expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
      end
    end
  end

  # describe '#cleanup_derivatives' do
  # end

  describe '#derivative_url' do
    let(:file_set) { ActiveEncodeFileSet.create }
    let(:external_uri) { "http://test.file" }
    let(:derivative) do
      file_set.build_derivative.tap do |d|
        d.label = 'high'
        d.external_file_uri = external_uri
      end
    end

    before do
      derivative
    end

    it 'returns the external uri' do
      expect(service.derivative_url('high')).to eq external_uri
    end

    it 'returns nil if no matching derivative' do
      expect(service.derivative_url('missing')).to be_nil
    end
  end
end
