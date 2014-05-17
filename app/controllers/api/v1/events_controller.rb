module Api
  module V1
    # EventsController
    # /api/v1/event/... serves WebSockets. This controller handles
    # all of them.
    #
    class EventsController < BackendController
      include Tubesock::Hijack

      # WebSocket /api/v1/events/bathrooms
      # Sends JSON representing the changing bathrooms to the socket
      # as they update.
      #
      def bathrooms
        hijack do |websocket|
          # TODO: Use one Redis connection. Creating a thread with a full
          # Redis connection per request is pretty expensive.
          thread = Thread.new do
            Redis.new.subscribe('bathroom') do |on|
              on.message { |_channel, message| websocket.send_data(message) }
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
