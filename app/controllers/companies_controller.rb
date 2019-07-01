# frozen_string_literal: true

class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[names locations]

  before_action :load_company, only: %i[show edit update widget]

  def index
    @companies = Companies::Searcher.new(filter_params,
                                         domain_country_context).call

    @companies_paginated = @companies.preload(:locations, :deals)
                                     .page(params[:page])
  end

  def show
    @investors = @company.deals.flat_map(&:investors).uniq
  end

  def new
    @company = Company.new

    @markets = Market.all
  end

  def create
    @markets = Market.all

    @company = Company.new(company_params)

    if @company.save
      create_company_markets
      create_investor(@company)

      Integrations::Clearbit.new(@company).enrich

      redirect_to(companies_path, notice: 'Successfully saved')
    else
      render :new
    end
  end

  def edit
    @markets = Market.all
  end

  def update
    @markets = Market.all

    if @company.update(company_params)
      redirect_to companies_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  def names
    render(json: autocomplete(:name) || [params[:term]], status: :ok)
  end

  def locations
    location = "CONCAT(locations.country, ' - ', locations.city) AS location"
    location_names = begin
      Company.joins(:locations)
             .select(location)
             .where(
               'locations.city ILIKE :term OR locations.country ILIKE :term',
               term: "%#{params[:term]}%"
             ).limit(20)
              .pluck(location)
              .presence
    end

    render(json: location_names || [params[:term]], status: :ok)
  end

  def widget
    @last_deal = @company&.deals&.last
    @last_funding_type = I18n.t("filters.labels.funding_type.#{@last_deal.round}") if @last_deal&.round.present?

    # rubocop:disable Rails/OutputSafety
    render('companies/widget.js.erb', layout: false,
                                      locals: {
                                        name: @company.name,
                                        permalink: @company.permalink,
                                        location: @company.all_headquarters,
                                        born_at: @company.born_date&.year,
                                        description: @company.description,
                                        image_url: @company.profile_image_url,
                                        last_funding_type: @last_funding_type,
                                        last_funding_value: @last_deal&.amount,
                                        widget_content: widget_content(@last_deal,
                                                                       @last_funding_type).html_safe,
                                        footer: true
                                      })
    # rubocop:enable Rails/OutputSafety
  end

  private

  COMPANY_PARAMS = %i[
    name employees_count founded_on description contact_email homepage_url
    facebook_url linkedin_url twitter_url google_plus_url phone_number
  ].freeze
  private_constant :COMPANY_PARAMS

  def load_company
    @company = Company.find_by!(permalink: params[:id])
  end

  def autocomplete(key)
    Company.where("#{key} ILIKE ?", "%#{params[:term]}%")
           .limit(20)
           .pluck(key)
           .presence
  end

  def alloweds
    params.require(:company).permit(
      *COMPANY_PARAMS,
      locations_attributes: %i[city country],
      company_markets_attributes: { market_id: [] }
    )
  end

  def filter_params
    return {} unless params[:filter] || params[:order]

    params.permit(:order, :type, filter: {})
  end

  def create_company_markets
    company_markets_attributes = alloweds[:company_markets_attributes]

    return unless company_markets_attributes

    company_markets_attributes[:market_id].delete_if(&:blank?)

    company_markets_attributes[:market_id].map do |market_id|
      @company.company_markets.create!(market_id: market_id)
    end
  end

  def company_params
    @company_params ||= begin
      locations_attributes = alloweds[:locations_attributes]

      return allowed_company if locations_attributes.to_h.values.all?(&:empty?)

      allowed_company.merge(
        locations_attributes: [{
          city: locations_attributes[:city].presence,
          country: locations_attributes[:country].presence
        }]
      )
    end
  end

  def allowed_company
    COMPANY_PARAMS.inject({}) do |acc, param|
      acc.merge(param => alloweds[param].presence)
    end
  end

  def investor?
    investor = params.require(:company).permit(:investor)[:investor]
    investor.presence == 'true'
  end

  def create_investor(company)
    Investor.create!(
      investable: company, tag: Investor::ANGEL, stage: Investor::SEED
    )
  end

  def widget_content(last_deal, last_funding_type)
    render_to_string('companies/widget_content.html.erb',
                     layout: false,
                     locals: {
                       name: @company.name,
                       permalink: @company.permalink,
                       location: @company.all_headquarters,
                       born_at: @company.born_date&.year,
                       description: @company.description,
                       image_url: @company.profile_image_url,
                       last_funding_type: last_funding_type,
                       last_funding_value: last_deal&.amount
                     }).squish.gsub("\'", "\\\\'")
  end
end
