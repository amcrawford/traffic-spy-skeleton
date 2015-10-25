require './test/test_helper'
require './test/payload_samples.rb'

class ViewEventDetails < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
    PayloadSamples.initial_payloads.each do |payload|
      post '/sources/jumpstartlab/data', payload
    end
  end

  def test_user_sees_header
    visit '/sources/jumpstartlab/events/socialLogin'
    assert page.has_content?("socialLogin")
  end

  def test_user_sees_received_count
    visit '/sources/jumpstartlab/events/socialLogin'
    assert page.has_content?("Event Received 7 Times")
  end

  def test_user_sees_hour_breakdown
    visit '/sources/jumpstartlab/events/socialLogin'
    assert page.has_content?("0: 0 1: 1 2: 1 3: 0 4: 0 5: 0 6: 0 7: 0 8: 0 9: 0 10: 0 11: 0 12: 0 13: 0 14: 0 15: 0 16: 0 17: 0 18: 0 19: 0 20: 1 21: 4 22: 0 23: 0")
  end
end
