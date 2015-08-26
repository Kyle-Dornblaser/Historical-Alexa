class Domain < ActiveRecord::Base
  extend FriendlyId
  has_many :ranks
  validates :name, presence: true, uniqueness: true
  validate :valid_domain_name
  before_validation :clean_name
  friendly_id :name, use: [:slugged, :finders]

  # override to keep periods in domain names
  def normalize_friendly_id(string)
    string
  end

  def self.parse(name)
    url = Domainatrix.parse(name)
    if url.domain.blank? || url.public_suffix.blank?
      nil
    else
      "#{url.domain}.#{url.public_suffix}"
    end
  end
  
  def last_rank
    self.ranks.last
  end
  
  def distributed_ranks(desired_count = 10.0)
    ranks = self.ranks.order(:created_at)
    times = []
    traffic_ranks = []
    
    # current number of data points
    current_count = ranks.size

    last_index = -1
    index = -1
    for i in 0..desired_count-1
      # Formula used to get even distribution of elements
      # http://stackoverflow.com/questions/9873626/choose-m-evenly-spaced-elements-from-a-sequence-of-length-n/9873935#9873935
      last_index = index
      index = (i * current_count / desired_count).ceil
      
      # Prevent out of bounds
      if index < current_count && last_index != index
        traffic_ranks << ranks[index]
      end
      # Break loop when we have reached the max index or surpassed it
      # Can repeat last index without this condition
      break if index >= current_count - 1
    end
    traffic_ranks
  end
  
  def self.update_all
    Domain.all.each do |domain|
      rank = Rank.create(domain_id: domain.id)
      rank.save
    end
  end

  private

  def valid_domain_name
    if Domain.parse(name).nil?
      errors.add(:name, 'must be valid domain name')
    end
  end

  def clean_name
    if name
      parsed_name = Domain.parse(name)
      # Check to make sure we aren't setting the name to nil.
      # That would add an extra validation error of name is blank.
      self.name = parsed_name if parsed_name
    end
  end
end
