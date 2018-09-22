# frozen_string_literal: true

require 'rails_helper'

describe Hyrax::ActiveEncode::OptionService do
  before(:all) do
    class ActiveEncodeFileSet < ::FileSet
      include Hyrax::ActiveEncode::FileSetBehavior
    end
  end

  after(:all) do
    Object.send(:remove_const, :ActiveEncodeFileSet)
  end

  describe '#self.call' do
    let(:file_set) { ActiveEncodeFileSet.new }
    let(:options) { described_class.call(file_set) }

    context 'with audio file set' do
      before do
        allow(file_set).to receive(:audio?).and_return(true)
      end

      it 'returns a hash array containing audio format options' do
        expect(options).to be_an Array
        expect(options).not_to be_empty
        options.each do |hash|
          expect(hash).to be_a Hash
          expect(hash).to include(:outputs)
          expect(hash[:outputs]).to be_an Array
          hash[:outputs].each do |output|
            expect(output).to be_a Hash
            expect(output).to include(:label)
            expect(output).to include(:ffmpeg_opt)
          end
        end
      end
    end

    context 'with video file set' do
      before do
        allow(file_set).to receive(:video?).and_return(true)
      end

      it 'returns a hash array containing video format options' do
        expect(options).to be_an(Array)
        expect(options).not_to be_empty
        options.each do |hash|
          expect(hash).to be_a(Hash)
          expect(hash).to include(:outputs)
          expect(hash[:outputs]).to be_an Array
          hash[:outputs].each do |output|
            expect(output).to be_a Hash
            expect(output).to include(:label)
            expect(output).to include(:ffmpeg_opt)
          end
        end
      end
    end
  end
end
