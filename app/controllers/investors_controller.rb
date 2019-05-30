# frozen_string_literal: true

class InvestorsController < ApplicationController
  before_action :authenticate_user!, except: %i[ranking index show]
  before_action :load_investor, only: %i[show edit update]

  def index
    @investors = Investors::Searcher.new(filter_params, domain_country_context)
                                    .call

    @investors_paginated = @investors.page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @investor.update(update_params)
      redirect_to investor_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  def ranking
    @investors = Investors::Ranking.new(ranking_params)
                                   .call
                                   .page(params[:page])
  end

  private

  def load_investor
    company_investor = Company.find_by(permalink: params[:id]).try(:investor)
    person_investor = Person.find_by(permalink: params[:id]).try(:investor)

    @investor = company_investor || person_investor
  end

  def load_investable(permalink)
    company = Company.find_by(permalink: permalink)
    person = Person.find_by(permalink: permalink)

    company || person
  end

  def update_params
    investable = load_investable(investor_params[:permalink])

    update_params = investor_params.permit(:status, :tag).to_h
    update_params[:investable_id] = investable&.id
    update_params[:investable_type] = investable&.class
    update_params[:stage] = investor_params[:stage] if investor_params[:stage].present?

    update_params
  end

  def filter_params
    return {} unless params[:filter]

    params.permit(:order, :type, filter: {})
  end

  def ranking_params
    params.permit(:type, :order)
  end

  def investor_params
    params.require(:investor).permit(:permalink, :status, :tag, :stage)
  end
end
