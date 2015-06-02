class Rank < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'
  belongs_to :domain
  validates :traffic_rank, presence: true
  before_validation :set_traffic_rank
  
  private
  
  def set_traffic_rank
    base_url = 'http://data.alexa.com/data?cli=10&url='
    domain = self.domain.name
    xml = Nokogiri::XML(open(base_url + domain))
    # Parses XML and gets node with traffic rank information.
    popularity_node = xml.xpath("//POPULARITY")
    # Won't set the traffic rank if it is a bad XML file.
    # This is usually because of an invalid domain.
    # Traffic rank validation will trigger an error.
    unless popularity_node.blank?
      traffic_rank = popularity_node[0].attributes["TEXT"].to_s
      self.traffic_rank = traffic_rank
    end
  end
  

end
