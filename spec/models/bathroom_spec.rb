require 'spec_helper'
require 'securerandom'

describe Bathroom, '#status' do
  it 'is either occupied or available' do
    expect(Bathroom.statuses.keys).to eq(['occupied', 'available'])
  end
end

describe Bathroom, 'validations' do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sparkcore_id) }
  it { should validate_uniqueness_of(:sparkcore_id) }
end

describe Bathroom, 'before_save callback' do
  let(:bathroom) { create(:bathroom) }

  it 'should not set the status_updated_at column before being saved' do
    expect { bathroom.save }.to_not change{ bathroom.status_updated_at }
  end

  it 'should set the status_updated_at column before being saved' do
    expect {
      bathroom.update_attribute(:status, 'occupied')
    }.to change{ bathroom.status_updated_at }
  end
end

describe Bathroom, 'after_save callback' do
  let(:bathroom) { create(:bathroom) }
  let(:json) { BathroomSerializer.new(bathroom).to_json }

  it 'sends a redis event named bathroom' do
    expect(Metricution::Redis).to receive(:publish).with('bathroom', json)
    bathroom.save
  end
end
