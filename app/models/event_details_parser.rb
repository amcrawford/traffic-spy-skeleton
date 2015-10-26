require_relative 'source'

class EventDetailsParser
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
    elsif event_data.empty?
      "No event with the give name has been defined"
    else
      "#{event_data[0].event_name}"
    end
  end

  def view
    !source || event_data.empty? ? :error : :event_details
  end

  def event_data
    source.payloads.where(:event_name =>  @params["event"])
  end
end
