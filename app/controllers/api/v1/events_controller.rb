module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers['Content-Type'] = 'text/event-stream'
      end

      def bathrooms
        response.headers['Content-Type'] = 'text/event-stream'
        sse = SSE.new(response.stream, retry: 300, event: "bathroom")
        redis = Redis.new
        redis.subscribe('bathroom') do |on|
          on.message do |channel, message|
            p JSON.parse(message)
            sse.write(JSON.parse(message))
          end
        end
      ensure
        redis.quit
        sse.close
      end
    end
  end
end
