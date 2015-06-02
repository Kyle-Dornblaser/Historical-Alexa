require 'rails_helper'

RSpec.describe Rank, type: :model do
  context 'Rank.create' do
    it 'should create a rank for a valid domain' do
       domain = Domain.create(name: 'google.com')
       rank = Rank.new(domain: domain)
       expect(rank.valid?).to eq(true)
    end
    
    it 'should not create a rank for an invalid domain' do
      # This passes domain check for validity, but obviously isn't valid
      domain = Domain.create(name: 'fake.fakeurl')
      rank = Rank.new(domain: domain)
      expect(rank.valid?).to eq(false)
    end
  end
end
