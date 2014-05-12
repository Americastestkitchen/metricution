require 'net/http'

module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers['Content-Type'] = 'text/event-stream'
      end

      def bathrooms
        sse = Metricution::SSE::Writer.new(response.stream)

        begin
          Metricution::Redis.subscribe('door') do |handler|
            handler.message do |channel, message|
              json     = JSON.parse(message)
              bathroom = Bathroom.find_by_sparkcore_id(json['coreid'])
              if bathroom
                status = json['data'] == 'opened' ? 'available' : 'occupied'
                bathroom.update_attribute(:status, status)
                payload = BathroomSerializer.new(bathroom).to_json
                sse.write(payload)
              end
            end
          end
        ensure
          sse.close
        end
      end

    end
  end
end