require './test/test_helper'
require './test/payload_samples'

class ViewAnalyticsTest < Minitest::Test
  include Rack::Test::Methods

  def create_database
    post '/sources', PayloadSamples.register_users

    PayloadSamples.initial_payloads.each do |payload|
        post '/sources/jumpstartlab/data', payload
    end
    @source = Source.find_by(:identifier => "jumpstartlab")
  end

  def test_url_list_in_order
    create_database
    assert_equal 6, Payload.count
    assert_equal [["http://jumpstartlab.com/index", 3], ["http://jumpstartlab.com/1", 1], ["http://jumpstartlab.com/2", 1]], @source.urls
  end

  def test_identifies_web_browser_from_user_agent
    skip
    create_database(3)
    assert_equal ({"Chrome" => 4}), @source.web_browsers
  end

  def test_identifies_os_from_user_agent
    skip
    create_database(2)
    assert_equal ({"OS X 10.8.2"=>3}), @source.os
  end

  def test_shows_screen_resolution
    skip
    create_database(2)
    assert_equal ({"1920 X 800"=>2, "1920 X 801"=>1}), @source.resolution
  end

  def test_calculates_average_response_time_per_url_in_order
    skip
    create_database(3)
    assert_equal [["http://jumpstartlab.com/2", 39], ["http://jumpstartlab.com/1", 38], ["http://jumpstartlab.com/0", 37]], @source.average_response_times
  end
end
