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

  Thread.new do
    loop do
      data = {data: (rand > 0.5 ? "opened" : "closed"), sparkcore_id: "sadsda"}
      puts data
      update_bathroom(data)
      Metricution::Redis.publish('door', data)
      sleep(1)
    end
  end

  # Send an event over Redis.
  sse.subscribe('door') do |message|
    data = JSON.parse(message)
    puts data
    update_bathroom(data)
    Metricution::Redis.publish('door', data)
  end

  sse.start
end


def update_bathroom(data)
  bathroom = Bathroom.find_by_sparkcore_id(data['coreid'])
  if bathroom
    status = data['data'] == 'opened' ? 'available' : 'occupied'
    bathroom.update_attribute(:status, status)
  end
end
