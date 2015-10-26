class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.text :name
      t.text :digest
      t.integer :source_id
    end

    create_table :events do |t|
      t.text :name
      t.integer :campaign_id
    end

    add_foreign_key :campaigns, :sources
    add_foreign_key :events, :campaigns
  end
end
