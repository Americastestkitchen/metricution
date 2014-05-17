# Bathroom
# Represents a state-full bathroom, where it's either
# occupied, or available. Keeps track of when the state changes.
#
class Bathroom < ActiveRecord::Base
  # TODO: Unknown state.
  enum status: [:occupied, :available]

  validates :name, presence: true
  validates :sparkcore_id, presence: true, uniqueness: true

  before_save do
    self.status_updated_at = DateTime.now.utc if status_changed?
  end

  after_save do
    json = Metricution::ActiveRecordSerializer.to_json(self)
    Metricution::Redis.publish('bathroom', json)
  end
end
