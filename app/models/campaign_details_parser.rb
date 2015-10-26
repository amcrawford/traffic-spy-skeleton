class CampaignDetailsParser
  def initialize(params)
    @params = params
  end

  def source
    Source.find_by(:identifier => @params["identifier"])
  end

  def campaign
    Campaign.find_by(:name => @params["campaign"])
  end

  def validate_campaign
    Campaign.where(:source_id => source.id)
            .exists?(:name => @params["campaign"])
  end

  def link
    "/sources/#{@params["identifier"]}/campaigns"
  end

  def campaign_events
    if validate_campaign
      events = Event.where(:campaign_id => campaign.id)
      names = events.map { |event| event[:name] }
      names.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    end
  end

  def view
    validate_campaign ? :campaign_details : :error
  end

  def message
    validate_campaign ? "#{@params["campaign"]}" : "No campaign with that name exists"
  end
end
