require './test/test_helper'

class RegisterCampaignTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
  end

  def test_user_can_successfully_register_a_campaign
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    assert_equal 200, last_response.status
    assert_equal 1, Campaign.count
    assert_equal 2, Event.count
  end

  def test_user_receives_missing_parameters_response_without_campaignName
    post '/sources/jumpstartlab/campaigns', {"eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    assert_equal 400, last_response.status
    assert_equal "Missing Parameters", last_response.body
    assert_equal 0, Campaign.count
    assert_equal 0, Event.count
  end

  def test_user_receives_missing_parameters_response_without_eventNames
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    assert_equal 400, last_response.status
    assert_equal "Missing Parameters", last_response.body
    assert_equal 0, Campaign.count
    assert_equal 0, Event.count
  end

  def test_user_receives_campaign_already_exists_response_for_campaign_with_same_name
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    assert_equal 200, last_response.status
    assert_equal 1, Campaign.count
    post '/sources/jumpstartlab/campaigns', {"campaignName"=>"socialSignup",
                                             "eventNames"=>["addedSocialThroughPromptA", "addedSocialThroughPromptB"],
                                             "splat"=>[],
                                             "captures"=>["jumpstartlab"],
                                             "identifier"=>"jumpstartlab"}
    assert_equal 403, last_response.status
    assert_equal "Digest has already been taken, Name has already been taken", last_response.body
    assert_equal 1, Campaign.count
    assert_equal 2, Event.count
  end
end
