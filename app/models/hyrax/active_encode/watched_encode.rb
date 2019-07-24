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

      def persistence_model_attributes(encode)
        display_title = encode.input.url.to_s.split('/').last
        options_hash = { display_title: display_title, work_id: encode.options[:work_id], work_type: encode.options[:work_type], file_set: encode.options[:file_set_id] }
        super.merge(options_hash.select { |_, v| v.present? })
      end
    end
  end
end
