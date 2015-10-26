class CampaignParser
  attr_accessor :body,
                :status

  def initialize(params)
    @params = params
  end

  def source
    Source.find_by(:identifier => @params["identifier"])
  end

  def list_campaigns
    if source
      Campaign.where(:source_id => source.id).map { |camp| camp[:name] }
    else
      []
    end
  end

  def message
    list_campaigns.empty? ? "No campaigns have been defined" : "#{source.identifier.capitalize}"
  end

  def view
    (source && !list_campaigns.empty?) ? :campaign_index : :error
  end

  def validate_payload
    @params.include?("campaignName") && @params.include?("eventNames")
  end

  def validate_source
    Source.exists?(:identifier => @params["identifier"])
  end

  def register_campaign
    if validate_payload && validate_source
      campaign = Campaign.new(name: @params["campaignName"],
                              digest: Digest::SHA2.hexdigest(@params.to_s),
                              source_id: source.id)
      if campaign.save
        @status = 200
        @params["eventNames"].each do |event|
          Event.create(name: event,
                       campaign_id: campaign.id)
        end
      elsif campaign.errors.full_messages.join(", ")
                                         .include?("already been taken")
        @status = 403
        @body = campaign.errors.full_messages.join(", ")
      else
        @status = 400
        @body = campaign.errors.full_messages.join(", ")
      end
    elsif !validate_source
      @status = 403
      @body = "Application not registered"
    else
      @status = 400
      @body = "Missing Parameters"
    end
  end

end
