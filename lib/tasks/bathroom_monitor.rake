require 'json'

desc "Monitor the bathroom"
task monitor_bathroom: :environment do
  # TODO: Don't listen to all events.
  uri = URI('https://api.spark.io/v1/events')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(uri)
  req["Authorization"] = "Bearer #{ENV['SPARK_AUTH_TOKEN']}"
  req["Content-Type"]  = "application/json"

  sse = Metricution::SSE::Reader.new(http, req)

  # TODO: Update a bathroom.
  sse.subscribe('Readings') do |data|
    p JSON.parse(data, max_nesting: 0)
  end

  sse.start
end
