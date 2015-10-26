require './test/test_helper'

class ViewCampaignDetailsTest < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
  end

  def test_user_can_view_campaign_details
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSigndown",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    visit '/sources/jumpstartlab/campaigns/socialSignup'
    assert page.has_content?("addedSocialThroughPromptA: 1")
    assert page.has_content?("addedSocialThroughPromptB: 1")
  end
end
