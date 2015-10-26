require './test/test_helper'

class ViewCampaignsTest < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
  end

  def test_user_can_view_campaigns_index
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
    visit '/sources/jumpstartlab/campaigns'
    assert page.has_content?("Campaign Index")
    assert page.has_content?("socialSignup")
    assert page.has_content?("socialSigndown")
  end

  def test_user_sees_message_when_no_campaigns_defined
    visit '/sources/jumpstartlab/campaigns'
    assert page.has_content?("Error Page")
    assert page.has_content?("No campaigns have been defined")
  end

  def test_user_can_navigate_to_campaign_details_page_for_single_campaign
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    visit '/sources/jumpstartlab/campaigns'
    click_link_or_button("socialSignup")
    assert_equal '/sources/jumpstartlab/campaigns/socialSignup', current_path
    assert page.has_content?("campaign details")
  end
end
