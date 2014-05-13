require 'json'

desc "Monitor the bathroom"
task monitor_bathroom: :environment do
  # uri = URI('https://api.spark.io/v1/events/door')
  # http = Net::HTTP.new(uri.host, uri.port)
  # http.use_ssl = true

  # req = Net::HTTP::Get.new(uri)
  # req["Authorization"] = "Bearer #{ENV['SPARK_AUTH_TOKEN']}"
  # req["Content-Type"]  = "application/json"

  # sse = Metricution::SSE::Reader.new(http, req)
  # sse.subscribe('door') { |message| update_bathroom(message) }
  # sse.start

  # Mock the core updating.
  thread = Thread.new do
    loop do
      val = rand > 0.5 ? 'opened' : 'closed'
      message = "{\"data\":\"#{val}\",\"coreid\":\"48ff6c065067555024221587\"}"
      update_bathroom(message)
      sleep(1)
    end
  end
  thread.join
end

RedisConnection = Redis.new

# Update bathroom records based on messages from spark cloud, sending
# a redis event to pass along to the frontend with the core's ID.
def update_bathroom(sparkcore_json)
  sparkcore_data = JSON.parse(sparkcore_json)
  bathroom = Bathroom.find_by_sparkcore_id(sparkcore_data['coreid'])
  if bathroom
    status = sparkcore_data['data'] == 'opened' ? 'available' : 'occupied'
    bathroom.update_attribute(:status, status)
    RedisConnection.publish('bathroom', Metricution::ActiveRecordSerializer.to_json(bathroom))
  else
    puts "Spark Core ID: #{sparkcore_data['coreid']} sending events, but is not in the database."
  end
end
