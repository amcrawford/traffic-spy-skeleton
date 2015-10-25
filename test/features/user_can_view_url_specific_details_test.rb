require './test/test_helper'
require './test/payload_samples.rb'

class ViewUrlDetails < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
    PayloadSamples.initial_payloads.each do |payload|
      post '/sources/jumpstartlab/data', payload
    end
  end

  def test_user_can_view_headers
    visit '/sources/jumpstartlab/urls/index'
    assert page.has_content?("Longest Response Time")
    assert page.has_content?("Shortest Response Time")
    assert page.has_content?("Average Response Time")
    assert page.has_content?("HTTP Verbs Have Been Used")
    assert page.has_content?("Most Popular Referrer")
    assert page.has_content?("Most Popular User Agent")
  end

  def test_user_can_view_data
    visit '/sources/jumpstartlab/urls/home'
    assert page.has_content?("40")
    assert page.has_content?("37")
    assert page.has_content?("38.5")
    assert page.has_content?("GET")
    assert page.has_content?("http://jumpstartlab.com")
    assert page.has_content?("Most Popular OS: OS X 10.8.2")
    assert page.has_content?("Most Popular Browser: Chrome")
  end

  def test_user_entering_url_that_has_not_been_submitted_sees_error
    visit '/sources/jumpstartlab/urls/notthere'
    assert page.has_content?("url has not been requested")
  end
end
