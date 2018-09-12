# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::DerivativeService do
  it 'includes the ActiveEncodeDerivativeService' do
    expect(described_class.services).to include Hyrax::ActiveEncode::ActiveEncodeDerivativeService
  end

  describe '#for' do
    before(:all) do
      class ActiveEncodeFileSet < ::FileSet
        include Hyrax::ActiveEncode::FileSetBehavior
      end
    end

    after(:all) do
      Object.send(:remove_const, :ActiveEncodeFileSet)
    end

    let(:file_set) { ActiveEncodeFileSet.new }

    before do
      allow(file_set).to receive(:mime_type).and_return("video/mp4")
    end

    it 'returns ActiveEncodeDerivativeService for a video file' do
      expect(described_class.for(file_set)).to be_a Hyrax::ActiveEncode::ActiveEncodeDerivativeService
    end
  end
end
