# frozen_string_literal: true
module Hyrax
  module ActiveEncode
    class WatchedEncode < ::ActiveEncode::Base
      include ::ActiveEncode::Persistence
      include ::ActiveEncode::Polling

      around_create do |encode, block|
        file_set_id = encode.options[:file_set_id]
        block.call
        ::FileSet.find(file_set_id).update(encode_global_id: encode.to_global_id.to_s) if file_set_id
      end
    end
  end
end
