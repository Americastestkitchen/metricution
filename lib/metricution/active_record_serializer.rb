require 'active_record'

module Metricution
  module ActiveRecordSerializer

    def self.to_json(object)
      if object.is_a?(ActiveRecord::Relation)
        root       = object.klass.to_s.downcase.pluralize
        serializer = (object.klass.to_s + "Serializer").constantize
        ActiveModel::ArraySerializer.new(object, each_serializer: serializer, root: root).to_json
      elsif object.is_a?(ActiveRecord::Base)
        serializer = (object.class.to_s + "Serializer").constantize
        serializer.new(object).to_json
      else
        raise ArgumentError, "object not an ActiveRecord::Relation or ActiveRecord::Base"
      end
    end

  end
end
