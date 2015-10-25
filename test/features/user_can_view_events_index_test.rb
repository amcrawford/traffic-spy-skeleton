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
    assert page.has_content?("socialLogin: 7")
    assert_equal '/sources/jumpstartlab/events', current_path
  end

  def test_event_links_to_event_details_page
    visit '/sources/jumpstartlab/events'
    assert_equal '/sources/jumpstartlab/events', current_path
    click_link_or_button('socialLogin_link')
    assert_equal '/sources/jumpstartlab/events/socialLogin', current_path
  end
end
