class AddForeignKeyColumnToPayload < ActiveRecord::Migration
  def change
    add_column :payloads, :source_id, :text
  end
end
