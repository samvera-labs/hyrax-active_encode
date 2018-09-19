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
    subject { described_class.call(file_set) }

    context 'with audio file set' do
      before do
        allow(file_set).to receive(:audio?).and_return(true)
      end

      it 'returns a hash array containing audio format options' do
        expect(subject).to be_an(Array)
        subject.each do |hash|
          expect(hash).to be_a(Hash)
          expect(hash).to include('label')
          expect(hash).to include('ffmpeg_opt')
        end
      end
    end

    context 'with video file set' do
      before do
        allow(file_set).to receive(:video?).and_return(true)
      end

      it 'returns a hash array containing video format options' do
        expect(subject).to be_an(Array)
        subject.each do |hash|
          expect(hash).to be_a(Hash)
          expect(hash).to include('label')
          expect(hash).to include('ffmpeg_opt')
        end
      end
    end
  end
end
