# frozen_string_literal: true

require 'rails_helper'
require 'shared_specs/derivative_service'

describe Hyrax::DerivativeService do
  let(:valid_file_set) { ::FileSet.new }

  it_behaves_like "a Hyrax::DerivativeService"

  it 'includes the ActiveEncodeDerivativeService' do
    expect(described_class.services).to include Hyrax::ActiveEncode::ActiveEncodeDerivativeService
  end

  describe '#for' do
    let(:file_set) { ::FileSet.new }

    before do
      allow(file_set).to receive(:mime_type).and_return("video/mp4")
    end

    it 'returns ActiveEncodeDerivativeService for a video file' do
      expect(described_class.for(file_set)).to be_a Hyrax::ActiveEncode::ActiveEncodeDerivativeService
    end
  end
end