class PayloadSamples
  def self.register_users
    { "identifier" => "jumpstartlab",
                       "rootUrl" => "http://jumpstartlab.com" }
  end

  def self.initial_payloads
    [{"payload"=> "{\"url\":\"http://jumpstartlab.com/index\",\"requestedAt\":\"2013-02-16 1:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                  \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                  \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.211\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/index\",\"requestedAt\":\"2013-02-16 2:38:30 -0700\",\"respondedIn\":14,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                    \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1720\",
                    \"resolutionHeight\":\"1000\",\"ip\":\"63.29.38.211\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/home\",\"requestedAt\":\"2013-02-16 21:38:30 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                    \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.211\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/index\",\"requestedAt\":\"2013-02-16 20:38:30 -0700\",\"respondedIn\":40,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                    \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.201\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/home\",\"requestedAt\":\"2013-02-14 21:38:30 -0700\",\"respondedIn\":40,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                    \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.201\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/analytics\",\"requestedAt\":\"2013-02-16 21:38:30 -0700\",\"respondedIn\":40,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                    \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                    \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.201\"}"},
      {"payload"=> "{\"url\":\"http://jumpstartlab.com/index\",\"requestedAt\":\"2013-02-16 21:38:30 -0700\",\"respondedIn\":40,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],
                 \"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_9) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",
                 \"resolutionHeight\":\"800\",\"ip\":\"63.29.38.201\"}"}
    ]
 end
end
