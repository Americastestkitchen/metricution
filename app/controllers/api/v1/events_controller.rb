module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers['Content-Type'] = 'text/event-stream'
      end

      def bathrooms
        sse = SSE.new(response.stream, retry: 300, event: "bathroomUpdated")
        redis = Redis.new
        redis.subscribe('bathroomUpdated') do |on|
          on.message do |channel, message|
            sse.write(message)
          end
        end
      ensure
        redis.quit
        sse.close
      end
    end
  end
end
