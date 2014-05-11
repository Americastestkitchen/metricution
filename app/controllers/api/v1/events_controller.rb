require 'net/http'

module Api
  module V1
    class EventsController < BackendController
      include Tubesock::Hijack

      def bathrooms
        hijack do |tubesock|
          Metricution::Redis.subscribe('door') do |handler|
            handler.message do |channel, message|
              bathroom = Bathroom.find_by_sparkcore_id(message['coreid'])
              payload = BathroomSerializer.new(bathroom).to_json
              tubesock.send_data(payload)
            end
          end
        end
      end

    end
  end
end
