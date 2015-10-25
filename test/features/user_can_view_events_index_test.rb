require './test/test_helper'
require './test/payload_samples.rb'

class ViewEventIndex < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
    PayloadSamples.initial_payloads.each do |payload|
      post '/sources/jumpstartlab/data', payload
    end
  end

  def test_user_can_view_index_of_events
    visit '/sources/jumpstartlab/events'
    assert page.has_content?("Event Index")
  end

end
