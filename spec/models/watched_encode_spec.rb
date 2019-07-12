# frozen_string_literal: true
require 'rails_helper'

describe Hyrax::ActiveEncode::WatchedEncode do
  let(:file_set) { FileSet.create }
  let(:display_title) { 'A readable title.' }
  let(:encode) { described_class.new("sample.mp4", file_set_id: file_set.id, display_title: display_title, work_id: file_set.id, work_type: 'GenericWork', progress: 100) }
  let(:completed_encode) do
    encode.clone.tap do |e|
      e.id = SecureRandom.uuid
      e.state = :completed
    end
  end

  before do
    # Return a completed encode so the polling job doesn't run forever.
    allow(described_class.engine_adapter).to receive(:create).and_return(completed_encode)
  end

  describe 'create' do
    it 'stores the encode global id on the file set' do
      encode.create!
      expect(file_set.reload.encode_global_id).to eq encode.to_global_id.to_s
    end
  end
end
