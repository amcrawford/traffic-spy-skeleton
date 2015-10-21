class AddForeignKeyToPayload < ActiveRecord::Migration
  def change
    add_foreign_key :payloads, :sources
  end
end
