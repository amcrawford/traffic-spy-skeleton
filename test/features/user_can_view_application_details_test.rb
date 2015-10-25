require './test/test_helper'

class ViewDetailsTest < FeatureTest
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
    PayloadSamples.initial_payloads.each do |payload|
      post '/sources/jumpstartlab/data', payload
    end
  end

  def test_user_can_view_all_data_at_homepage
    visit '/sources/jumpstartlab'
    assert page.has_content?("Requested URLs")
    assert page.has_content?("http://jumpstartlab.com/team: 1")

    assert page.has_content?("Web Browser Breakdown")
    assert page.has_content?("Chrome: 2")

    assert page.has_content?("OS Breakdown")
    assert page.has_content?("OS X 10.8.2: 2")

    assert page.has_content?("Screen Resolution")
    assert page.has_content?("1920 X 1280: 2")

    assert page.has_content?("Average URL Response Time")
    assert page.has_content?("http://jumpstartlab.com/team: 37")

    assert page.has_content?("Links to URL Stats")
    assert page.has_content?("http://jumpstartlab.com/team")

    assert page.has_content?("Links to Event Stats")
    assert page.has_content?("Event stats")
  end

  def test_registered_user_with_no_payload_sees_no_data
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

  def test_unregistered_user_returns_error_message
    skip
    visit '/sources/google'
    assert page.has_content? "identifier does not exist"
  end

  def test_url_links_redirect_to_individual_stat_pages
    skip
    visit '/sources/jumpstartlab'
    click_link_or_button("/blog_link")
    assert_equal "/sources/jumpstartlab/urls/blog", current_path
  end

  def test_url_links_redirect_to_event_stats_page
    skip
    visit '/sources/jumpstartlab'
    click_link_or_button("event_link")
    assert_equal "/sources/jumpstartlab/events", current_path
  end
end
