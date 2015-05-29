class DomainsController < ApplicationController
  before_action :set_domain, only: [:show]

  # GET /domains
  # GET /domains.json
  def index
    @domains = Domain.all
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
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
      render 'home/index'
    end
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
