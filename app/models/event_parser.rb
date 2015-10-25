require_relative 'source'
class EventParser
  attr_accessor :status, :body
  def initialize(params)
    @params = params
  end

  def source
    Source.find_by(:identifier => @params["identifier"])
  end

  def message
    if !source
      "Identifier does not exist"
    elsif list_events.empty?
      "No events have been defined"
    end
  end

  def view
    !source || list_events.empty? ? :error : :event_index
  end

  def list_events
    source ? source.events.to_h : {}
  end
end
