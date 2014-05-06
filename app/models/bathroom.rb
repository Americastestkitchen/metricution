class Bathroom < ActiveRecord::Base
  validates :name, presence: true
  validates :sparkcore_id, presence: true
end
