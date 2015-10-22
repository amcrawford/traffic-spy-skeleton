class Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  validates_uniqueness_of :identifier, :root_url

  has_many :payloads

  def urls
    urls = payloads.group("url").count
    binding.pry
  end
end
