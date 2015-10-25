require './test/test_helper'
require './test/payload_samples'

class ViewAnalyticsTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
    PayloadSamples.initial_payloads.each do |payload|
        post '/sources/jumpstartlab/data', payload
    end
    @source = Source.find_by(:identifier => "jumpstartlab")
  end

  def test_url_list_in_order
    assert_equal 7, Payload.count
    assert_equal [["http://jumpstartlab.com/index", 4], ["http://jumpstartlab.com/home", 2], ["http://jumpstartlab.com/analytics", 1]], @source.urls
  end

  def test_identifies_web_browser_from_user_agent
    assert_equal ({"Chrome" => 7}), @source.web_browsers
  end

  def test_identifies_os_from_user_agent_in_order
    assert_equal ({"OS X 10.8.2"=>6, "OS X 10.8.9"=>1}), @source.os
  end

  def test_shows_screen_resolution_in_order
    assert_equal ({"1920 X 800"=>6, "1720 X 1000"=>1}), @source.resolution
  end

  def test_calculates_average_response_time_per_url_in_order
    assert_equal [["http://jumpstartlab.com/analytics", 40], ["http://jumpstartlab.com/home", 38], ["http://jumpstartlab.com/index", 32]], @source.average_response_times
  end
end
