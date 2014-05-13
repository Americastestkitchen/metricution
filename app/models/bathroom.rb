class Bathroom < ActiveRecord::Base
  validates :name, presence: true
  validates :sparkcore_id, presence: true, uniqueness: true

  after_save do
    Metricution::Redis.publish('bathroom', Metricution::ActiveRecordSerializer.to_json(self))
  end
end
