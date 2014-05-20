class Bathroom < ActiveRecord::Base
  enum status: [:occupied, :available]

  validates :name, presence: true
  validates :sparkcore_id, presence: true, uniqueness: true

  before_save do
    self.status_updated_at = DateTime.now.utc if status_changed?
  end

  after_save do
    Metricution::Redis.publish('bathroomUpdated', Metricution::ActiveRecordSerializer.to_json(self))
  end
end
