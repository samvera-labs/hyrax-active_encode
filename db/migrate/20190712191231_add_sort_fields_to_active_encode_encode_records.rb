class AddSortFieldsToActiveEncodeEncodeRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :active_encode_encode_records, :display_title, :string
    add_index :active_encode_encode_records, :display_title
    add_column :active_encode_encode_records, :file_set, :string
    add_index :active_encode_encode_records, :file_set
    add_column :active_encode_encode_records, :work_id, :string
    add_index :active_encode_encode_records, :work_id
    add_column :active_encode_encode_records, :work_type, :string
  end
end
