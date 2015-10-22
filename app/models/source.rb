class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates_uniqueness_of :identifier, :root_url

  has_many :payloads

  def urls
    payloads.group("url").count # verify if this is sorting??
  end

  def average_response_times
    # Payload.average(:responded_in)
    binding.pry

    payloads.group(:url).average(:responded_in)
    payloads.sort_by {|payload| payload[1] }.reverse
  end


end
