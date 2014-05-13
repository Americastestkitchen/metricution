require 'json'

desc "Monitor the bathroom"
task monitor_bathroom: :environment do
  uri = URI('https://api.spark.io/v1/events/door')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(uri)
  req["Authorization"] = "Bearer #{ENV['SPARK_AUTH_TOKEN']}"
  req["Content-Type"]  = "application/json"

  sse = Metricution::SSE::Reader.new(http, req)

  # Mock the core updating.
  Thread.new do
    loop do
      val = rand > 0.5 ? 'opened' : 'closed'
      json = "{\"data\":\"#{val}\",\"coreid\":\"48ff6c065067555024221587\"}"
      update_bathroom(json)
      sleep(2)
    end
  end

  sse.subscribe('door') { |json| update_bathroom(json) }
  sse.start
end

# Update bathroom records based on messages from spark cloud, sending
# a redis event to pass along to the frontend with the core's ID.
def update_bathroom(json)
  data     = JSON.parse(json)
  bathroom = Bathroom.find_by_sparkcore_id(data['coreid'])
  if bathroom
    status = data['data'] == 'opened' ? 'available' : 'occupied'
    bathroom.update_attribute(:status, status)
  end
  Metricution::Redis.publish('bathroom', data['coreid'])
end
