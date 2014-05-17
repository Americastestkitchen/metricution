require 'securerandom'

FactoryGirl.define do

  factory :bathroom do
    name '4th Floor'
    sparkcore_id SecureRandom.hex(12)
    status :available
  end

end
