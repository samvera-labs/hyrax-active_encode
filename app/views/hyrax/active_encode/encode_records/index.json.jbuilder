# frozen_string_literal: true

json.array! @encode_records, partial: 'hyrax/active_encode/encode_records/encode_record', as: :encode_record
