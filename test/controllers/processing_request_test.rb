require './test/test_helper'
require './test/payload_samples'

class ProcessingRequestTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    post '/sources', PayloadSamples.register_users
  end

  def test_request_contains_unique_payload_returns_success
    post '/sources/jumpstartlab/data', PayloadSamples.initial_payloads.first
    assert_equal 200, last_response.status
    assert_equal "", last_response.body
    assert_equal 1, Payload.count
  end

  def test_request_contains_missing_payload_returns_bad_request
    post '/sources/jumpstartlab/data', Hash.new
    assert_equal 400, last_response.status
    assert_equal "Missing Payload", last_response.body
    assert_equal 0, Payload.count
  end

  def test_request_already_received_returns_forbidden
    post '/sources/jumpstartlab/data', PayloadSamples.initial_payloads.first
    post '/sources/jumpstartlab/data', PayloadSamples.initial_payloads.first
    assert_equal 1, Payload.count
    assert_equal 403, last_response.status
    assert_equal "Digest has already been taken", last_response.body
  end

  def test_request_application_not_registered_returns_forbidden
    post '/sources/turing/data', PayloadSamples.initial_payloads.first
    assert_equal 0, Payload.count
    assert_equal 403, last_response.status
    assert_equal "Application not registered", last_response.body
  end

end
