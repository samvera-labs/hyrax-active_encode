# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::DerivativeService do
  it 'includes the ActiveEncodeDerivativeService' do
    expect(described_class.services).to include Hyrax::ActiveEncode::ActiveEncodeDerivativeService
  end

  it 'still includes Hyrax::FileSetDerivativeService' do
    expect(described_class.services).to include Hyrax::FileSetDerivativesService
  end

  describe '#for' do
    before(:all) do
      class DefaultFileSet < ActiveFedora::Base
        include ::Hyrax::FileSetBehavior
      end
    end

    after(:all) do
      Object.send(:remove_const, :DefaultFileSet)
    end

    let(:valid_file_set) { FileSet.new }
    let(:invalid_file_set) { DefaultFileSet.new }

    before do
      allow(valid_file_set).to receive(:mime_type).and_return("video/mp4")
      allow(invalid_file_set).to receive(:mime_type).and_return("video/mp4")
    end

    it 'returns ActiveEncodeDerivativeService for a valid video file' do
      expect(described_class.for(valid_file_set)).to be_a Hyrax::ActiveEncode::ActiveEncodeDerivativeService
    end

    it 'returns FileSetDerivativeService for an invalid video file' do
      expect(described_class.for(invalid_file_set)).to be_a Hyrax::FileSetDerivativesService
    end
  end
end
