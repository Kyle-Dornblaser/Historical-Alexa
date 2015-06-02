require 'rails_helper'

RSpec.describe Domain, type: :model do
  context 'Domain.create' do
    it 'requires a name' do
      expect { Domain.create }.to_not change { Domain.count }
    end
  
    it 'has a unique name' do
      Domain.create(name: 'google.com')
      expect { Domain.create(name: 'google.com') }.to_not change { Domain.count }
    end
  
    it 'has one record, not matter the subdomain or path' do
      Domain.create(name: 'google.com')
      domains = %w(http://google.com www.google.com http://www.google.com
                   https://www.google.com google.com/path/path/path/)
      domains.each do |domain|
        expect { Domain.create(name: domain) }.to_not change { Domain.count }
      end
    end
  
    # 'anything.anything' is a valid domain name
    it 'must be a valid domain name' do
      domains = %w(google .com)
      domains.each do |domain|
        expect { Domain.create(name: domain) }.to_not change { Domain.count }
      end
    end
  end
  context 'Domain.parse' do
    it 'should return a correctly parsed domain' do
      domains = [
                  ['http://google.com', 'google.com'],
                  ['google.co.uk', 'google.co.uk'],
                  ['http://www.google.com', 'google.com'],
                  ['www.google.com', 'google.com']
                ]
      domains.each { |input, output| expect(Domain.parse(input)).to eq(output) }
    end
    it 'should return nil for unparsable domains' do
      domains = %w(google .com . foo)
      domains.each do |domain|
        expect(Domain.parse(domain)).to be_nil
      end
    end
  end
end
