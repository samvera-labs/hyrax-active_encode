# frozen_string_literal: true
require 'rails_helper'

describe Hyrax::ActiveEncode::WatchedEncode do
  let(:work) { FactoryBot.create(:work_with_one_file) }
  let(:file_set) { work.file_sets.first }
  let(:display_title) { 'A readable title.' }
  let(:encode) do
    described_class.new("sample.mp4",
                        updated_at: Time.zone.now,
                        created_at: Time.zone.now,
                        file_set_id: file_set.id,
                        work_id: work.id,
                        work_type: 'GenericWork')
  end
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
    it 'stores sort and search fields on the encode record' do
      encode.create!
      encode_record = ActiveEncode::EncodeRecord.where(global_id: encode.to_global_id.to_s).first
      expect(encode_record.work_type).to eq encode.options[:work_type]
      expect(encode_record.work_id).to eq encode.options[:work_id]
      expect(encode_record.file_set).to eq encode.options[:file_set_id]
      expect(encode_record.display_title).to eq encode.input.url.split('/').last
    end
  end
end
