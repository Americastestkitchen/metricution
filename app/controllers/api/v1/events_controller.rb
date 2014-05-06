require 'net/http'

module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers['Content-Type'] = 'text/event-stream'
      end

      def bathrooms
        sse = Metricution::SSE.new(response.stream)

        begin
          10.times { sse.write "foo"; sleep(2) }
        ensure
          sse.close
        end
      end

    end
  end
end