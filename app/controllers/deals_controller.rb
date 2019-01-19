# frozen_string_literal: true

class DealsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :only_admin_or_moderator!, only: %i[edit update]

  def index
    @deals = DealSearcher.new(
      filter_params,
      domain_country_context
    ).call

    @deals_paginated = @deals.page(params[:page])
  end

  def new
    @companies = Company.where(domain_country_context: domain_country_context)
    @investors = Investor.where(domain_country_context: domain_country_context)

    @deal = Deal.new
  end

  def create
    @companies = Company.where(domain_country_context: domain_country_context)
    @investors = Investor.where(domain_country_context: domain_country_context)

    @deal = Deal.new(deal_params)

    if @deal.save
      redirect_to deals_path, notice: 'Successfully saved'
    else
      render :new
    end
  end

  def edit
    @companies = Company.where(domain_country_context: domain_country_context)
    @investors = Investor.where(domain_country_context: domain_country_context)

    @deal = Deal.find(params[:id])
  end

  def show
    @deal = Deal.find(params[:id])
  end

  def update
    @companies = Company.where(domain_country_context: domain_country_context)
    @investors = Investor.where(domain_country_context: domain_country_context)

    @deal = Deal.find(params[:id])

    if @deal.update(deal_params)
      redirect_to deals_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  private

  DEAL_PARAMS = %i[
    close_date company_id category round amount_currency
    amount_cents pre_valuation_cents source_url status
  ].freeze
  private_constant :DEAL_PARAMS

  def filter_params
    return {} unless params[:filter]

    params.require(:filter).permit!
  end

  def alloweds
    params.require(:deal).permit(
      *DEAL_PARAMS, deal_investors_attributes: [:investor_id]
    )
  end

  def deal_params
    @deal_params ||=
      begin
        allowed_deal.merge(
        deal_investors_attributes: [
          { investor_id: alloweds[:deal_investors_attributes][:investor_id] }
        ]
        )
      end
  end

  def allowed_deal
    DEAL_PARAMS.inject({}) do |acc, param|
      acc.merge(param => alloweds[param].presence)
    end
  end

  def only_admin_or_moderator!
    unless [User::ADMIN, User::MODERATOR].include?(current_user&.role)
      flash[:error] = 'Unauthorized'
      redirect_to root_path
    end
  end
end
