require './test/test_helper'

class ProcessingRequestTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    post '/sources', { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
    @complete_payload = {"payload"=> "{\"url\":\"http://jumpstartlab.com/blog\",
                    \"requestedAt\":\"2013-02-16 21:38:28 -0700\",
                    \"respondedIn\":37,
                    \"referredBy\":\"http://jumpstartlab.com\",
                    \"requestType\":\"GET\",
                    \"parameters\":[],
                    \"eventName\": \"socialLogin\",
                    \"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",
                    \"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"1280\",
                    \"ip\":\"63.29.38.211\"}",
                    "splat"=>[],
                    "captures"=>["jumpstartlab"],
                    "identifier"=>"jumpstartlab"}
  end

  def test_request_contains_unique_payload_returns_success
    post '/sources/jumpstartlab/data', @complete_payload
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
    post '/sources/jumpstartlab/data', @complete_payload
    post '/sources/jumpstartlab/data', @complete_payload
    assert_equal 1, Payload.count
    assert_equal 403, last_response.status
    assert_equal "Digest has already been taken", last_response.body
  end

  def test_request_application_not_registered_returns_forbidden
    post '/sources/turing/data', @complete_payload
    assert_equal 0, Payload.count
    assert_equal 403, last_response.status
    assert_equal "Application not registered", last_response.body
  end

end
