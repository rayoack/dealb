# frozen_string_literal: true

class DealsController < ApplicationController
  include DealsHelper, InvestorsHelper
  before_action :authenticate_user!, only: %i[edit update destroy]
  before_action :only_admin_or_moderator!, only: %i[edit update destroy]

  before_action :load_companies, only: %i[new create edit update]
  before_action :load_person, only: %i[new create edi update]
  before_action :load_investors, only: %i[new create edit update]
  before_action :load_deal, only: %i[edit show update destroy]

  def index
    @deals = DealSearcher.new(filter_params, domain_country_context).call
    @deals_paginated = @deals.page(params[:page])
    
    @deals_paginated.map { |deal|
      if deal.amount_dolar.nil?
        convert_to_dolar(deal)
      end
    }
  end

  def new
    @deal = Deal.new

  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      convert_to_dolar(@deal)
      redirect_to deals_path, notice: I18n.t('deals.messages.create.success')
    else
      render :new, flash: { error: I18n.t('deals.messages.create.failure') }
    end
  end

  def edit; end

  def show; end

  def update
    if @deal.update(deal_params)
      convert_to_dolar(@deal)
      redirect_to deals_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  def destroy
    if @deal.delete
      redirect_to deals_path, notice: 'Successfully deleted.'
    else
      redirect_to deals_path
    end
  end

  private

  DEAL_PARAMS = %i[
    close_date company_id category round amount_currency pre_valuation_currency
    amount pre_valuation source_url status amount_dolar pre_valuation_dolar
    investor_ids
  ].freeze

  def filter_params
    return {} unless params[:filter] || params[:order]

    params.permit(:order, :type, filter: {})
  end

  def alloweds
    params.require(:deal).permit(
      *DEAL_PARAMS, :investor_ids => []
    )
    # params.require(:deal).permit(
    #  *DEAL_PARAMS, deal_investor_attributes: [:investor_id]
    # )
    # .merge(investor_ids: params.require(:deal)
    # .require(:deal_investors_attributes)[:investor_id])
  end

  def deal_params
    @deal_params ||=
      begin
        allowed_deal.merge(user_id: current_user.id)
        # allowed_deal.merge(
        #   user_id: current_user.id,
        #   deal_investors_attributes: alloweds[:investor_ids].select(&:present?).map { |id| { investor_id: id } }
        # )
      end
  end

  def allowed_deal
    DEAL_PARAMS.inject({}) do |acc, param|
      print "PARAM =>", param, alloweds[param].presence, "\n"

      if param == :investor_ids 
        acc.merge(param => ensure_investor(alloweds[param].presence)) 
      else
        acc.merge(param => alloweds[param].presence)
      end
    end
  end

  def ensure_investor( ids )
    check_id = ->(id) {
      id.gsub("Investor_", "") if id.include? "Investor_"
      
      curr_id = id.gsub(/[A-Za-z_]/, "")
      investor_type = id.gsub(/[0-9_]/, "")

      if( curr_id == "" ) 
        return ""
      end

      curr_investor = Investor.select(:id).where(investable_type: investor_type, investable_id: curr_id ).first

      if curr_investor != nil
        return curr_investor.id 
      end

      investable_to_create = find_investable(curr_id, investor_type)
      if( investable_to_create == "" || investable_to_create.nil? ) 
        return ""
      end

      investor = Investor.create!(
        investable: investable_to_create, tag: Investor::ANGEL, stage: Investor::SEED
      )

      return investor.id
    }
    ids = ids.collect(&check_id)
    ids
  end

  def find_investable(id, investor_type)
    if investor_type == 'Company'
      Company.find(id)
    elsif investor_type == 'Person'
      Person.find(id)
    end
  end

  def only_admin_or_moderator!
    return if [User::ADMIN, User::MODERATOR].include?(current_user&.role)

    flash[:error] = 'Unauthorized'
    redirect_to root_path
  end

  def load_companies
    @companies = Company.select(:id, :name).where(domain_country_context: domain_country_context).order(:name)
  end

  def load_person
    @persons = Person.select(:id, :first_name, :last_name).where(domain_country_context: domain_country_context).order(:first_name, :last_name)
  end
  def load_investors
    @investors = all_investable_entities( domain_country_context )

    
    @allInvestors = @investors.collect { |c| 
      [c["name"], "#{c["type"]}_#{c["id"]}"] 
    }
  end

  def load_deal
    @deal = Deal.find(params[:id])
  end
end
