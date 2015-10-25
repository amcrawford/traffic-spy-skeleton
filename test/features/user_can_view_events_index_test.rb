require './test/test_helper'

class ViewEventIndex < MiniTest::Test
  include Rack::Test::Methods

  def setup

  end

  def test_user_can_view_index_of_events
    visit '/sources/jumpstartlab/events'
    assert page.has_content?("Event Index")

  end

end
