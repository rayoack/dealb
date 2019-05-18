# frozen_string_literal: true

class DealsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update destroy]
  before_action :only_admin_or_moderator!, only: %i[edit update destroy]

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
      redirect_to deals_path, notice: I18n.t('deals.messages.create.success')
    else
      render :new, flash: { error: I18n.t('deals.messages.create.failure') }
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

  def destroy
    @deal = Deal.find(params[:id])

    if @deal.delete
      redirect_to deals_path, notice: 'Successfully deleted.'
    else
      redirect_to deals_path
    end
  end

  private

  DEAL_PARAMS = %i[
    close_date company_id category round amount_currency
    amount_cents pre_valuation_cents source_url status
  ].freeze
  private_constant :DEAL_PARAMS

  def filter_params
    return {} unless params[:filter] || params[:order]

    params.permit(:order, :type, filter: {})
  end

  def alloweds
    params.require(:deal).permit(
      *DEAL_PARAMS, deal_investor_attributes: [:investor_id]
    ).merge(investor_ids: params.require(:deal)
                                .require(:deal_investors_attributes)[:investor_id])
  end

  def deal_params
    @deal_params ||=
      begin
        allowed_deal.merge(
          user_id: current_user.id,
          deal_investors_attributes: alloweds[:investor_ids].select(&:present?)
                                                            .map { |id| { investor_id: id } }
        )
      end
  end

  def allowed_deal
    DEAL_PARAMS.inject({}) do |acc, param|
      acc.merge(param => alloweds[param].presence)
    end
  end

  def only_admin_or_moderator!
    return if [User::ADMIN, User::MODERATOR].include?(current_user&.role)

    flash[:error] = 'Unauthorized'
    redirect_to root_path
  end
end
