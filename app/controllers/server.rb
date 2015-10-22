module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/sources/:identifier' do
      @source = Source.find_by(:identifier => params["identifier"])
      if !@source
        @message = "identifier does not exist" # TODO
      end
      erb :details
    end

    not_found do
      erb :error
    end

    post '/sources' do
      # if valid parsed & not already in database
      source = Source.new(identifier: params[:identifier], root_url: params[:rootUrl])
      if source.save
        status 200
        body ({"identifier" => params[:identifier]}.to_json)
      elsif source.errors.full_messages.join(", ").include?("already been taken")
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
        elsif payload.errors.full_messages.join(", ").include?("already been taken")
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
  end
end
