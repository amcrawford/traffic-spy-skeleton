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
      source = Source.new(identifier: params[:identifier],
                          root_url: params[:rootUrl])
      if source.save
        status 200
        body ({"identifier" => params[:identifier]}.to_json)
      elsif source.errors.full_messages.join(", ")
                                       .include?("already been taken")
        status 403
        body source.errors.full_messages.join(", ")
      else
        status 400
        body source.errors.full_messages.join(", ")
      end
    end

    post '/sources/:identifier/data' do
      parser = Parser.new(params)
      parser.post_payload
      status parser.status
      body parser.body
    end

    get '/sources/:identifier/urls/:relative' do
      @source = Source.find_by(:identifier => params["identifier"])
      @full_url = "#{@source.root_url}/#{params[:relative]}"
      if !@source
        @message = "Identifier does not exist"
        erb :error
      else
        if @source.payloads.where(:url => @full_url).empty?
          @message = "url has not been requested"
          erb :error
        else
          @message = "#{@source.root_url}/#{params[:relative]} - Page Details"
          erb :url_stats
        end
      end
    end

    # get '/sources/:identifier/urls/:relative/:path' do
    #   erb :
    # end

    get '/sources/:identifier/events' do
      @source = Source.find_by(:identifier => params["identifier"])
      if !@source
        @message = "Identifier does not exist"
        erb :error
      else
        @events = @source.events.to_h
        if !@events.empty?
          erb :event_index
        else
          @message = "No events have been defined"
          erb :error
        end
      end
    end

    get '/sources/:identifier/events/:event' do
      @source = Source.find_by(:identifier => params["identifier"])
      if !@source
        @message = "Identifier does not exist"
        erb :error
      else
        @event_data = @source.payloads.where(:event_name =>  params["event"])
        if !@event_data.empty?
          @message = "#{@event_data[0].event_name}"
          @request_hours = @source.request_times(@event_data)
          @total_received = @event_data.count
          erb :event_details
        else
          @message = "No event with the give name has been defined"
          @link = "/sources/#{params["identifier"]}/events"
          @link_message = "Events Index"
          erb :error
        end
      end
    end

  end
end
