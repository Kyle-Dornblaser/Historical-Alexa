class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validate :valid_domain_name
  before_validation :clean_name

  private

  def valid_domain_name
    url = Domainatrix.parse(name)
    if url.domain.blank? || url.public_suffix.blank?
      errors.add(:name, 'must be valid domain name')
    end
  end

  def clean_name
    if name
      url = Domainatrix.parse(name)
      self.name = "#{url.domain}.#{url.public_suffix}"
    end
  end
end
