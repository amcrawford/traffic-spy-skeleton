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
      # validate user
        # return status and body
      # receive data and pass to view (as instance vars.)
      # route to view


      @source = Source.find_by(:identifier => params["identifier"])
      if !@source
        @message = "identifier does not exist"
        erb :error
      else
        @message = "#{@source.identifier.capitalize}"
        @parsed_paths = @source.urls.map{ |payload| URI(payload.first).path }
        erb :details
      end
    end

    post '/sources' do
      # if valid parsed & not already in database
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
      if params.include?("payload") && Source.exists?(:identifier => params["identifier"])
        digest = Digest::SHA2.hexdigest(params.to_s)
        source_id = Source.where(identifier: params["identifier"]).first.id
        parsed = JSON.parse(params["payload"])
        payload = Payload.new(url: parsed["url"],
                              requested_at: parsed["requestedAt"],
                              responded_in: parsed["respondedIn"],
                              referred_by: parsed["referredBy"],
                              request_type: parsed["requestType"],
                              parameters: parsed["parameters"],
                              event_name: parsed["eventName"],
                              user_agent: parsed["userAgent"],
                              resolution_width: parsed["resolutionWidth"],
                              resolution_height: parsed["resolutionHeight"],
                              ip: parsed["ip"],
                              digest: digest,
                              source_id: source_id)
        if payload.save
          status 200
          body ""
        elsif payload.errors.full_messages.join(", ")
                                          .include?("already been taken")
          status 403
          body payload.errors.full_messages.join(", ")
        else
          status 400
          body payload.errors.full_messages.join(", ")
        end

      elsif !Source.exists?(:identifier => params["identifier"])
        status 403
        body "Application not registered"
      else
        status 400
        body "Missing Payload"
      end
    end

    get '/sources/:identifier/urls/:relative' do
      @source = Source.find_by(:identifier => params["identifier"])
      @full_url = "#{@source.root_url}/#{params[:relative]}"
      if !@source
        @message = "url has not been requested"
        erb :error
      else
        @message = "#{@source.root_url}/#{params[:relative]} - Page Details"
        erb :url_stats
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
