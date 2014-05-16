FactoryGirl.define do
  sequence(:sparkcore_id) {|n| "12341#{n}"}

  factory :bathroom do
    name '4th Floor'
    sparkcore_id
  end
end
