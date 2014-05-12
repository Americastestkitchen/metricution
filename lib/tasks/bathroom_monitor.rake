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

  # Send an event over Redis.
  sse.subscribe('door') do |data|
    Metricution::Redis.publish('door', data)
    puts data
  end

  sse.start
end
