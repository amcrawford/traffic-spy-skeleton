class Parser
  def initialize(params)
    @params = params
  end

  def source
    Source.find_by(:identifier => @params["identifier"])
  end

  def message
    if !source
      "identifier does not exist"
    else
      "#{source.identifier.capitalize}"
    end
  end

  def view
    !source ? :error : :details
  end

  def parsed_paths
    source.urls.map{ |payload| URI(payload.first).path } if source
  end
end
