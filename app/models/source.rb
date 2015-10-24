class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates_uniqueness_of :identifier, :root_url

  has_many :payloads

  def urls
    payloads.group("url").count.sort_by { |k,v| -v } # verify if this is sorting??
  end

  def average_response_times
    average_response_times = payloads.group(:url).average(:responded_in)
    results = {}
    average_response_times.each { |k,v| results[k] = v.to_i  }
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

  def longest_response_time(url)
    payloads.where(:url => url).maximum("responded_in")
  end

  def shortest_response_time(url)
    payloads.where(:url => url).minimum("responded_in")
  end

  def average_response_time(url)
    payloads.where(:url =>  url).average("responded_in")
  end

  def http_verbs_used(url)
    payloads.where(:url => url).select(:request_type).all.map { |request| request.request_type }.uniq
  end

  def most_common_referrers(url)
    referrers = payloads.where(:url => url).group(:referred_by).order('count_id DESC').limit(1).count(:id)
  end

  def most_common_os(url)
    oss = payloads.where(:url => url).select(:user_agent)
                  .map{|payload| UserAgent.parse(payload.user_agent).os}
    popular_os = oss.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    popular_os.invert.max[1]
  end

  def most_common_browser(url)
    browser = payloads.where(:url => url).select(:user_agent)
                  .map{|payload| UserAgent.parse(payload.user_agent).browser}
    popular_browser = browser.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    popular_browser.invert.max[1]
  end

end
