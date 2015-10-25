require_relative 'source'
class Parser
  attr_accessor :status, :body
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

  def validate_user_is_registered
    Source.exists?(:identifier => @params["identifier"])
  end

  def validate_params_contain_payload
    @params.include?("payload")
  end

  def post_source
    source = Source.new(identifier: @params[:identifier],
                        root_url: @params[:rootUrl])
    if source.save
      @status = 200
      @body = ({"identifier" => @params[:identifier]}.to_json)
    elsif source.errors.full_messages.join(", ")
                                     .include?("already been taken")
      @status = 403
      @body = source.errors.full_messages.join(", ")
    else
      @status = 400
      @body = source.errors.full_messages.join(", ")
    end
  end



  def post_payload
    if validate_params_contain_payload && validate_user_is_registered
      digest = Digest::SHA2.hexdigest(@params.to_s)
      source_id = Source.where(identifier: @params["identifier"]).first.id
      parsed = JSON.parse(@params["payload"])
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
        @status = 200
        @body = ""
      elsif payload.errors.full_messages.join(", ")
        .include?("already been taken")
        @status = 403
        @body = payload.errors.full_messages.join(", ")
      else
        @status =  400
        @body = payload.errors.full_messages.join(", ")
      end

    elsif !Source.exists?(:identifier => @params["identifier"])
      @status = 403
      @body = "Application not registered"
    else
      @status = 400
      @body = "Missing Payload"
    end
  end
end
