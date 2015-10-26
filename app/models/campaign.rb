class Campaign < ActiveRecord::Base
  validates_presence_of :name,
                        :source_id
  validates_uniqueness_of :digest,
                          :name
  belongs_to :sources
  has_many :events
end
