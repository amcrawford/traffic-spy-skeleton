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

# CAMPAIGNS
    post '/sources/:identifier/campaigns' do
      campaign_parser = CampaignParser.new(params)
      campaign_parser.register_campaign
      status campaign_parser.status
      body campaign_parser.body
    end

    get '/sources/:identifier/campaigns' do
      parser = CampaignParser.new(params)
      @source = parser.source
      @campaigns = parser.list_campaigns
      @message = parser.message
      erb parser.view
    end

    get '/sources/:identifier/campaigns/:campaign' do
      parser = CampaignDetailsParser.new(params)
      @events = parser.campaign_events
      @message = parser.message
      @link = parser.link
      @link_message = "Campaign Index"
      erb parser.view
    end

  end
end
