module Api
  module V1
    class EventsController < BackendController
      include ActionController::Live

      before_action do
        response.headers['Content-Type'] = 'text/event-stream'
      end

      after_action do
        p "closing"
        ActiveRecord::Base.connection_pool.release_connection
      end

      def bathrooms
        sse = Metricution::SSE::Writer.new(response.stream)
        Metricution::PGEvents.subscribe('bathroom_update') do |event, payload|
          Bathroom.uncached do
            bathroom = Bathroom.find(payload)
            p bathroom
            json = Metricution::ActiveRecordSerializer.to_json(bathroom)
            sse.write(json, event: 'bathroomUpdate')
          end
        end
        Metricution::PGEvents.subscribe('browser_reload') do |a,b|
          sse.write(nil, event: 'browserReload')
        end
        Metricution::PGEvents.start_listening
      ensure
        sse.close
      end
    end
  end
end
