require './test/test_helper'

class ViewDetailsTest < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
    post '/sources/jumpstartlab/data', {"payload"=> "{\"url\":\"http://jumpstartlab.com/blog\",
                    \"requestedAt\":\"2013-02-16 21:38:28 -0700\",
                    \"respondedIn\":37,
                    \"referredBy\":\"http://jumpstartlab.com\",
                    \"requestType\":\"GET\",
                    \"parameters\":[],
                    \"eventName\": \"socialLogin\",
                    \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",
                    \"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"1280\",
                    \"ip\":\"63.29.38.211\"}",
                    "splat"=>[],
                    "captures"=>["jumpstartlab"],
                    "identifier"=>"jumpstartlab"}
    post '/sources/jumpstartlab/data', {"payload"=> "{\"url\":\"http://jumpstartlab.com/team\",
                    \"requestedAt\":\"2013-02-16 21:38:28 -0700\",
                    \"respondedIn\":37,
                    \"referredBy\":\"http://jumpstartlab.com\",
                    \"requestType\":\"GET\",
                    \"parameters\":[],
                    \"eventName\": \"socialLogin\",
                    \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",
                    \"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"1280\",
                    \"ip\":\"63.29.38.211\"}",
                    "splat"=>[],
                    "captures"=>["jumpstartlab"],
                    "identifier"=>"jumpstartlab"}
  end

  def test_user_can_view_all_data_at_homepage
    skip
    visit '/sources/jumpstartlab'
    assert page.has_content?("Requested URLs")
    assert page.has_content?("Web Browser Breakdown")
    assert page.has_content?("OS Breakdown")
    assert page.has_content?("Screen Resolution")
    assert page.has_content?("Average URL Response Time")
    assert page.has_content?("Links to URL Stats")
    assert page.has_content?("Links to Event Stats")
  end

  def test_registered_user_with_no_payload_sees_error_message_and_no_data
    skip
    visit '/sources/jumpstartlab'
    within('#data')
      page.has_content?("Requested URLs")
  end

  def test_unregistered_user_returns_error_message
    skip
    visit '/sources/google'
    assert_equal ERROR MESSAGE
  end
end
