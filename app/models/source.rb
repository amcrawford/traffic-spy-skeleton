class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates_uniqueness_of :identifier, :root_url

  has_many :payloads

  def urls
    payloads.group("url").count # verify if this is sorting??
  end

  def average_response_times
    something = payloads.group(:url).average(:responded_in)
    results = {}
    something.each { |k,v| results[k] = v.to_i  }
    results.sort_by { |k,v| -v }
  end


end
