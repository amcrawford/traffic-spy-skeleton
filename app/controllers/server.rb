module TrafficSpy
require 'uri'

  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    get '/sources/:identifier' do
      parser = Parser.new(params)
      @source = parser.source
      @message = parser.message
      @parsed_paths = parser.parsed_paths
      erb parser.view
    end

    post '/sources' do
      parser = Parser.new(params)
      parser.post_source
      status parser.status
      body parser.body
    end

    post '/sources/:identifier/data' do
      parser = Parser.new(params)
      parser.post_payload
      status parser.status
      body parser.body
    end

    get '/sources/:identifier/urls/:relative' do
      parser = UrlParser.new(params)
      @source = parser.source
      @full_url = "#{@source.root_url}/#{params[:relative]}"
      parser.set_full_url(@full_url)
      @message = parser.message
      erb parser.view
    end

    get '/sources/:identifier/events' do
      parser = EventParser.new(params)
      @source = parser.source
      @events = parser.list_events
      @message = parser.message
      erb parser.view
    end

    get '/sources/:identifier/events/:event' do
      parser = EventDetailsParser.new(params)
      @source = parser.source
      @message = parser.message
      @event_data = parser.event_data
      @link = "/sources/#{params["identifier"]}/events"
      @link_message = "Events Index"
      @request_hours = @source.request_times(@event_data)
      @total_received = @event_data.count
      erb parser.view
    end

  end
end
