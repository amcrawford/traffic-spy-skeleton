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


end
