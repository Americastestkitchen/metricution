desc "Monitor the bathroom"
task monitor_bathrooms: :environment do
  uri = URI('https://api.spark.io/v1/events/door')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  req = Net::HTTP::Get.new(uri)
  req["Authorization"] = "Bearer #{ENV['SPARK_AUTH_TOKEN']}"
  req["Content-Type"]  = "application/json"

  sse = Metricution::SSE::Reader.new(http, req)
  sse.subscribe('door') do |message|
    puts message
    sparkcore_data = JSON.parse(message)
    status = sparkcore_data['data'] == 'opened' ? 'available' : 'occupied'
    bathroom = Bathroom.where(sparkcore_id: sparkcore_data['coreid'])
                       .first_or_create
    bathroom.update_attribute(:status, status)
  end
  sse.start
end
