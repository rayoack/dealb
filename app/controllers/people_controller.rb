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
      if investor?
        create_investor(@person) 
      else
        delete_investor(@person)
      end
    # if @person.update(alloweds)
      redirect_to people_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  def destroy
    delete_investor(@person)
    if @person.delete
      redirect_to people_path, notice: 'Successfully deleted.'
    else
      redirect_to people_path
    end
  end

  private

  PERSON_PARAMS = %i[
    first_name last_name bio description occupation born_on gender phone_number
    email website_url facebook_url twitter_url google_plus_url linkedin_url
  ].freeze
  private_constant :PERSON_PARAMS

  def alloweds
    params.require(:person).permit(
        *PERSON_PARAMS,
        person_companies_attributes: [:company_id, :job_title, :_destroy],
        person_locations_attributes: [:location_id, :_destroy],
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
      .merge(params.require(:person).permit(person_companies_attributes: [:id, :company_id, :job_title, :_destroy]))
      .merge(params.require(:person).permit(person_locations_attributes: [:id, :location_id, :_destroy]))
  end

  def create_investor(person)
    Investor.create!(
      investable: person, tag: Investor::ANGEL, stage: Investor::SEED
    )
  end

  def delete_investor(person)
    person.try(:investor).delete
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
