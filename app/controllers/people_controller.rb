class PeopleController < ApplicationController
  before_action :load_companies, only: %i[new create edit update]
  before_action :load_person, only: %i[edit show update destroy]

  def index
    @people = PersonSearcher.new(filter_params, domain_country_context).call
    @people_paginated = @people.page(params[:page])
  end

  def show
    @deals = Array(@person.investor.try(:deal_investors)).map(&:deal)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      current_user.update(person: @person) if current_user.person.blank?
      create_investor(@person) if investor?

      Integrations::Clearbit.new(@person).enrich if Rails.env.production?

      redirect_to people_path, notice: 'Successfully saved'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @person.update(person_params)
      redirect_to people_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  private

  PERSON_PARAMS = %i[
    first_name last_name bio occupation born_on gender phone_number
    email website_url facebook_url twitter_url google_plus_url linkedin_url
  ].freeze
  private_constant :PERSON_PARAMS

  def alloweds
    params.require(:person).permit(
      *PERSON_PARAMS,
      person_companies_attributes: [:company_id],
      locations_attributes: %i[city country]
    )
  end

  def investor?
    investor = params.require(:person).permit(:investor)[:investor]
    investor.presence == 'true'
  end

  def allowed_person
    PERSON_PARAMS.inject({}) do |acc, param|
      acc.merge(param => alloweds[param].presence)
    end
  end

  def filter_params
    return {} unless params[:filter] || params[:order]

    params.permit(:order, :type, filter: {})
  end

  def person_params
    @person_params ||= allowed_person
      .merge(locations_attributes)
      .merge(person_companies_attributes)
  end

  def locations_attributes
    locations_attributes = alloweds[:locations_attributes]

    return {} if locations_attributes.to_h.values.all?(&:empty?)

    {
      locations_attributes: [
        {
          city: locations_attributes[:city].presence,
          country: locations_attributes[:country].presence
        }
      ]
    }
  end

  def person_companies_attributes
    person_companies_attributes = alloweds[:person_companies_attributes]

    return {} if person_companies_attributes.to_h.values.all?(&:empty?)

    {
      person_companies_attributes: [
        {
          company_id: person_companies_attributes[:company_id].presence,
          job_title: alloweds[:occupation].presence
        }
      ]
    }
  end

  def create_investor(person)
    Investor.create!(
      investable: person, tag: Investor::ANGEL, stage: Investor::SEED
    )
  end

  def load_companies
    @companies = Company # .select(:id, :name)
      .where(domain_country_context: domain_country_context)
      .order(:name)
  end

  def load_person
    @person = Person.find_by!(permalink: params[:id])
  end
end
