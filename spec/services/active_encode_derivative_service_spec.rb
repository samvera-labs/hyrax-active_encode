# frozen_string_literal: true

require 'rails_helper'
require 'shared_specs/derivative_service'

describe Hyrax::ActiveEncode::ActiveEncodeDerivativeService do
  before(:all) do
    class ActiveEncodeFileSet < ::FileSet
      include Hyrax::ActiveEncode::FileSetBehavior
    end
  end

  after(:all) do
    Object.send(:remove_const, :ActiveEncodeFileSet)
  end

  let(:original_file) { Hydra::PCDM::File.new(miem_type: 'video/mp4') }
  let(:valid_file_set) { ActiveEncodeFileSet.new.tap { |file_set| file_set.original_file = original_file } }

  let(:file_set) { ActiveEncodeFileSet.new }
  let(:service) { described_class.new(file_set) }

  it_behaves_like "a Hyrax::DerivativeService"

  describe '#valid?' do
    subject { service.valid? }

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

  # describe '#create_derivatives' do
  #   it 'calls the ActiveEncode runner with the original file' do
  #
  #   end
  #
  #   it 'passes the encode class' do
  #
  #   end
  # end
  #
  # describe '#cleanup_derivatives' do
  # end

  describe '#derivative_url' do
    let(:external_uri) { "http://test.file" }
    let(:derivative) do
      file_set.build_derivative.tap do |d|
        d.id = 'an_id'
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
