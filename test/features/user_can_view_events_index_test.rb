require './test/test_helper'
require './test/payload_samples.rb'

class ViewEventIndex < MiniTest::Test
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users

  end

  def test_user_can_view_index_of_events
    visit '/sources/jumpstartlab/events'
    assert page.has_content?("Event Index")

  end

end
