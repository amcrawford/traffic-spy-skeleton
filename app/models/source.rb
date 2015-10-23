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

  def web_browsers
    pay = payloads.select(:user_agent)
                  .map{|payload| UserAgent.parse(payload.user_agent).browser}
    pay.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
  end

  def os
    oss = payloads.select(:user_agent)
                  .map{|payload| UserAgent.parse(payload.user_agent).os}
    oss.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
  end

  def resolution
    resolution = payloads.select(:resolution_width, :resolution_height)
                         .map{|payload| "#{payload.resolution_width} X #{payload.resolution_height}"}
    resolution.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
  end
end
