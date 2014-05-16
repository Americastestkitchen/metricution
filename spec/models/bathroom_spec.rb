require 'spec_helper'

describe Bathroom, 'validations' do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sparkcore_id) }
  it { should validate_uniqueness_of(:sparkcore_id) }
end

describe Bathroom, 'before_save callback' do
  it 'should not set the status_updated_at column before being saved' do
    bathroom = build(:bathroom)

    expect{
      bathroom.save
    }.to_not change{bathroom.status_updated_at}
  end

  it 'should set the status_updated_at column before being saved' do
    bathroom = create(:bathroom)

    expect{
      bathroom.update_attribute(:status, 'available')
    }.to change{bathroom.status_updated_at}
  end
end
