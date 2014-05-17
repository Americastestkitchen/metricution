require 'active_record'

module Metricution
  # ActiveRecordSerializer
  # Serializes both ActiveRecord::Relation and ActiveRecord::Base objects
  # with serializers that match thier class name.
  #
  # For example a class `Foo` would NEED a serializer named `FooSerializer`.
  #
  module ActiveRecordSerializer
    def self.to_json(object)
      if object.is_a?(ActiveRecord::Relation)
        array(object)
      elsif object.is_a?(ActiveRecord::Base)
        single(object)
      else
        fail ArgumentError,
             'object not an ActiveRecord::Relation or ActiveRecord::Base'
      end
    end

    private

    def self.single(object)
      serializer = ("#{object.class}Serializer").constantize
      serializer.new(object).to_json
    end

    def self.array(object)
      root = object.klass.to_s.downcase.pluralize
      serializer_class = ("#{object.klass}Serializer").constantize
      serializer =
        ActiveModel::ArraySerializer.new object,
                                         each_serializer: serializer_class,
                                         root: root
      serializer.to_json
    end
  end
end
