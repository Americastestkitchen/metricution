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

  # TODO: Send a event to make the sever send a SSE.
  sse.subscribe('door') do |data|
    # Parse the data.
    json = JSON.parse(data)

    # Find and update the core in the database.
    bathroom = Bathroom.find_by_sparkcore_id(json['coreid'])
    status   = json['data'] == 'opened' ? 'available' : 'occupied'
    bathroom.update_attribute(:status, status) if bathroom

    # Log this event.
    puts json
  end

  sse.start
end
