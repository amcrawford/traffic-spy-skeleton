class Payload < ActiveRecord::Base
  validates_presence_of :url,
                        :requested_at,
                        :responded_in,
                        :referred_by,
                        :request_type,
                        :parameters,
                        :event_name,
                        :user_agent,
                        :resolution_width,
                        :resolution_height,
                        :ip,
                        :digest,
                        :source_id

  validates_uniqueness_of :digest
  belongs_to :sources
end
