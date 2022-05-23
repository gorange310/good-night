require 'rails_helper'

RSpec.describe UserClockInService do
  fixtures :all
  let(:user) { users(:user1) }
  subject(:service) { UserClockInService.new(user).call }

  describe 'user has no sleep record' do
    it 'returns a sleep without seconds' do
      expect { service }.to change(Sleep, :count).by(1)
      expect(service).to be_a_kind_of(Sleep)
      expect(service.seconds).to be_nil
      expect(user.sleeps.find_by(seconds: nil)).to be_present
    end
  end

  describe 'user has sleep record' do
    before { user.sleeps.create }
    it 'returns persisted sleep with seconds' do
      expect { service }.to change(Sleep, :count).by(0)
      expect(service).to be_a_kind_of(Sleep)
      expect(service.seconds).to be_present
      expect(user.sleeps.find_by(seconds: nil)).to be_nil
      expect(user.sleeps.where.not(seconds: nil)).to be_present
    end
  end
end
