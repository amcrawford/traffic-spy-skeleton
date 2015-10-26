require_relative 'source'

class UrlParser
  attr_accessor :status, :body
  def initialize(params)
    @params = params
  end

  def source
    Source.find_by(:identifier => @params["identifier"])
  end

  def message
    if valid_url
      "url has not been requested"
    else
      "#{source.root_url}/#{@params[:relative]} - Page Details"
    end
  end

  def view
    valid_url ? :error : :url_stats
  end

  def set_full_url(full_url)
    @full_url = full_url
  end

  def valid_url
    source.payloads.where(:url => @full_url).empty?
  end

end
