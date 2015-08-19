class DomainsController < ApplicationController
  before_action :set_domain, only: [:show]

  # GET /domains
  # GET /domains.json
  def index
    @domains = Domain.all.order(:name)
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    ranks = @domain.ranks
    times = []
    traffic_ranks = []

    # max number of data points
    desired_count = 10.0
    # current number of data points
    current_count = ranks.size

    if current_count === 1
      traffic_ranks << 0
      times << (ranks.first.created_at - 1.day).strftime("%B %d, %Y")
    end

    for i in 0..desired_count-1
      # Formula used to get even distribution of elements
      # http://stackoverflow.com/questions/9873626/choose-m-evenly-spaced-elements-from-a-sequence-of-length-n/9873935#9873935
      index = (i * current_count / desired_count).ceil
      # Prevent out of bounds
      if index < current_count
        traffic_ranks << ranks[index].traffic_rank
        times << ranks[index].created_at.strftime("%B %d, %Y")
      end
      # Break loop when we have reached the max index or surpassed it
      # Can repeat last index without this condition
      break if index >= current_count - 1
    end

    @data = {
        labels: times,
        datasets: [
            {
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: traffic_ranks
            }
        ]
    }
    @options = {
        width: 500,
        height: 300,
        class: 'chart'
    }
  end

  # POST /domains
  # POST /domains.json
  # Used on search submission
  def create
    parsed_domain = Domain.parse(domain_params[:name])
    if parsed_domain
      @domain = Domain.where(name: parsed_domain).first_or_create
    else
      @domain = Domain.create(name: domain_params[:name])
    end

    rank = Rank.new(domain: @domain)
    unless rank.valid?
      @domain.destroy
      # This will cause validation to fail and an error message to be shown.
      @domain = Domain.create(name: 'invalid name')
      rank.destroy
    end

    if @domain.id
      if @domain.ranks.size === 0
        notice = 'You are the first to ask about this domain. Traffic rank stored.'
        rank.save
      elsif Time.now - @domain.last_rank.created_at >= 1.day
        notice = 'You are the first to ask about this domain today. Traffic rank stored.'
        rank.save
      else
        notice = 'Traffic rank up to date.'
        # Don't save because already up to date
        rank.destroy
      end
      flash[:success] = notice
      redirect_to @domain
    else
      flash[:danger] = @domain.errors.full_messages
      redirect_to :back
    end
  end
  
  def compare
    domain1 = Domain.find(params[:id1])
    domain2 = Domain.find(params[:id2])
    @domains = [domain1, domain2]
    
    all_ranks = []
    all_times = []
    
    @domains.each.with_index do |domain, index|
      ranks = domain.ranks
      times = []
      traffic_ranks = []
      
  
      # max number of data points
      desired_count = 10.0
      # current number of data points
      current_count = ranks.size
  
      for i in 0..desired_count-1
        # Formula used to get even distribution of elements
        # http://stackoverflow.com/questions/9873626/choose-m-evenly-spaced-elements-from-a-sequence-of-length-n/9873935#9873935
        index = (i * current_count / desired_count).ceil
        # Prevent out of bounds
        if index < current_count
          traffic_ranks << ranks[index]
          all_times << ranks[index].created_at.beginning_of_day
        end
        # Break loop when we have reached the max index or surpassed it
        # Can repeat last index without this condition
        break if index >= current_count - 1
      end
      
      all_ranks << traffic_ranks
    end
    
    traffic_ranks = [[], []]
    
    all_times.sort!
    all_times.uniq!
    
    
    all_times.each do |time|
      all_ranks.each.with_index do |rank, index|
        if all_ranks[index].size > 0 && all_ranks[index].first.created_at.beginning_of_day === time 
          traffic_ranks[index] << all_ranks[index].first.traffic_rank
          all_ranks[index].shift
        elsif traffic_ranks[index].size > 0
          traffic_ranks[index] << traffic_ranks[index].last
        else
          traffic_ranks[index] << 0
        end
      end
    end
    
    all_times = all_times.map { |time| time.strftime("%B %d, %Y") }
    
    

    @data = {
        labels: all_times,
        datasets: [
            {
                label: @domains[0].name,
                fillColor: "rgba(0,0,255,0.2)",
                strokeColor: "rgba(0,0,255,1)",
                pointColor: "rgba(0,0,255,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(0,0,255,1)",
                data: traffic_ranks[0]
            },
            {
                label: @domains[1].name,
                fillColor: "rgba(255,0,0,0.2)",
                strokeColor: "rgba(255,0,0,1)",
                pointColor: "rgba(255,0,0,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(255,0,0,1)",
                data: traffic_ranks[1]
            }
            
            
        ]
    }
    @options = {
        width: 800,
        height: 400,
        class: 'chart'
    }
    
    
  
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    @domain = Domain.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def domain_params
    params.require(:domain).permit(:name)
  end
end
