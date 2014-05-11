module Api
  module V1
    class EventsController < BackendController
      include Tubesock::Hijack

      def bathrooms
        hijack do |tubesock|

          tubesock.onopen do |data|
            tubesock.send_data(json(Bathroom.all))
          end

          thread = Thread.new do
            Metricution::Redis.subscribe('door') do |on|
              on.message do |channel, message|
                data = JSON.parse(message)
                bathroom = Bathroom.find_by_sparkcore_id(data['coreid'])
                tubesock.send_data(json(bathroom))
              end
            end
          end

          tubesock.onclose do
            thread.kill
          end

        end
      end

      private

      def json(data)
        if data.is_a?(ActiveRecord::Relation)
          root       = data.klass.to_s.downcase.pluralize
          serializer = (data.klass.to_s + "Serializer").constantize
          ActiveModel::ArraySerializer.new(data, each_serializer: serializer, root: root).to_json
        elsif data.is_a?(ActiveRecord::Base)
          serializer = (data.class.to_s + "Serializer").constantize
          serializer.new(data).to_json
        else
          raise ArgumentError, "data not an ActiveRecord::Relation or ActiveRecord::Base"
        end
      end
    end
  end
end
