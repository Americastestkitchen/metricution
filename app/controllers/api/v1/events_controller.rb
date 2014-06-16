module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers["Content-Type"] = "text/event-stream"
      end

      def bathrooms
        sse = Metricution::SSE::Writer.new(response.stream)

        # TODO: Use one Redis connection. Creating a full
        # Redis connection per request is pretty expensive.
        redis = Redis.new
        redis.subscribe('bathroom') do |on|
          on.message do |channel, message|
            sse.write(message, event: 'bathroom')
          end
        end

      # Rescue user closing connection.
      rescue IOError
        logger.into "stream closed"

      # Clean up the action.
      ensure
        redis.quit
        sse.close
      end
    end
  end
end
