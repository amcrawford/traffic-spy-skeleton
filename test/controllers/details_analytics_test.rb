require './test/test_helper'

class ViewAnalyticsTest < Minitest::Test
  include Rack::Test::Methods

  def create_database(number)
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
    number.times do |i|
      post '/sources/jumpstartlab/data', {"payload"=> "{\"url\":\"http://jumpstartlab.com/#{i}\",
                    \"requestedAt\":\"2013-02-16 21:38:28 -0700\",
                    \"respondedIn\":#{37 + i},
                    \"referredBy\":\"http://jumpstartlab.com\",
                    \"requestType\":\"GET\",
                    \"parameters\":[],
                    \"eventName\": \"socialLogin\",
                    \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",
                    \"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"#{800 + i}\",
                    \"ip\":\"63.29.38.211\"}",
                    "splat"=>[],
                    "captures"=>["jumpstartlab"],
                    "identifier"=>"jumpstartlab"}
      @source = Source.find_by(:identifier => "jumpstartlab")
    end

    post '/sources/jumpstartlab/data', {"payload"=> "{\"url\":\"http://jumpstartlab.com/0\",
                  \"requestedAt\":\"2013-02-16 21:38:28 -0700\",
                  \"respondedIn\":37,
                  \"referredBy\":\"http://jumpstartlab.com\",
                  \"requestType\":\"GET\",
                  \"parameters\":[],
                  \"eventName\": \"socialLogin\",
                  \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",
                  \"resolutionWidth\":\"1920\",
                  \"resolutionHeight\":\"800\",
                  \"ip\":\"63.29.38.221\"}",
                  "splat"=>[],
                  "captures"=>["jumpstartlab"],
                  "identifier"=>"jumpstartlab"}
    @source = Source.find_by(:identifier => "jumpstartlab")

  end

  def test_url_list_in_order
    create_database(3)
    create_database(1)
    assert_equal 4, Payload.count
    assert_equal [["http://jumpstartlab.com/0", 2], ["http://jumpstartlab.com/1", 1], ["http://jumpstartlab.com/2", 1]], @source.urls
  end

  def test_identifies_web_browser_from_user_agent
    create_database(3)
    assert_equal ({"Chrome" => 4}), @source.web_browsers
  end

  def test_identifies_os_from_user_agent
    create_database(2)
    assert_equal ({"OS X 10.8.2"=>3}), @source.os
  end

  def test_shows_screen_resolution
    create_database(2)
    assert_equal ({"1920 X 800"=>2, "1920 X 801"=>1}), @source.resolution
  end

  def test_calculates_average_response_time_per_url_in_order
    create_database(3)
    assert_equal [["http://jumpstartlab.com/2", 39], ["http://jumpstartlab.com/1", 38], ["http://jumpstartlab.com/0", 37]], @source.average_response_times
  end
end
