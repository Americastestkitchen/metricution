module Api
  module V1
    class EventsController < BackendController
      include Tubesock::Hijack

      def bathrooms
        hijack do |websocket|
          # Send all of the bathrooms when the client connects.
          # This allows us to serve the client with one connection.
          websocket.onopen do |data|
            websocket.send_data(Metricution::ActiveRecordSerializer.to_json(Bathroom.all))
          end

          # TODO: Use one Redis connection. Creating a thread with a full
          # Redis connection per request is pretty expensive.
          thread = Thread.new do
            Redis.new.subscribe('bathroom') do |on|
              on.message do |channel, message|
                websocket.send_data(message)
              end
            end
          end

          # Clean up the thread.
          websocket.onclose do
            thread.kill
          end
        end
      end
    end
  end
end
