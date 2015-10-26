class Event < ActiveRecord::Base
  validates_presence_of :name,
                        :campaign_id
  belongs_to :campaigns
end
