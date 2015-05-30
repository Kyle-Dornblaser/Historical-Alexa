class Domain < ActiveRecord::Base
  extend FriendlyId
  has_many :ranks
  validates :name, presence: true, uniqueness: true
  validate :valid_domain_name
  before_validation :clean_name
  friendly_id :name, use: [:slugged], slug_column: :name

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
