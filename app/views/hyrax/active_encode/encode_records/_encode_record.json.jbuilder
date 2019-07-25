# frozen_string_literal: true

json.extract! encode_record, :id, :global_id, :state, :adapter, :title, :raw_object, :created_at, :updated_at
json.url encode_record_url(encode_record.id, format: :json)
