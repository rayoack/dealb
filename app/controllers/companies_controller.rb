# frozen_string_literal: true
require 'json'
require 'aws-sdk-s3'

class CompaniesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[names]

  before_action :load_company, only: %i[show edit update widget destroy]

  def index
    @markets = Market.all
    @companies = Companies::Searcher.new(filter_params,
                                         domain_country_context).call
    @companies_paginated = @companies.page(params[:page])
  end

  def show
    @investors = @company.deals.flat_map(&:investors).uniq
    @last_deal = @company.deals.last

    @isAcquired = false
    if @last_deal && @last_deal.category == Deal::WAS_ACQUIRED_BY
      @company.status = Company::ACQUIRED
    end
  end

  def new
    @company = Company.new

    @markets = Market.all
  end

  def create
    @markets = Market.all

    @company = Company.new(company_params)

    #return render( json: @company_params )
    if @company.save
      # create_company_markets
      create_investor(@company) if investor?
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
      if investor?
        create_investor(@company) 
      else
        delete_investor(@company)
      end
      redirect_to companies_path, notice: 'Successfully updated'
    else
      render :edit
    end
  end

  def destroy
    delete_investor(@company)
    if @company.delete
      redirect_to companies_path, notice: 'Successfully deleted.'
    else
      redirect_to companies_path
    end
  end

  def names
    render(json: autocomplete(:name) || [params[:term]], status: :ok)
  end

  def import
    @company = Company.new

    render :import
  end

  def csvimport(  )
    file = params["csv"]["File"]

    s3 = Aws::S3::Client.new( 
      access_key_id: 'AKIA37SVVXBHYQC3NTVA', 
      region: 'us-east-1',
      secret_access_key: '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' )
    
    
    name = "y97vpchuzi86/public/#{Time.now}-#{file.original_filename}"

    res = s3.put_object(
      bucket: 'cloud-cube', 
      key: name, 
      acl: 'public-read',
      body: file.tempfile)
    
    res = s3.put_object_acl( 
        grant_read: "uri=http://acs.amazonaws.com/groups/global/AllUsers",
        bucket: 'cloud-cube', 
        key: name)
    
    csv = ImportCsv.new( filename: "#{name}", status: 'pending', import_type: params["import"]["import_type"] )
    csv.save

    render json: 'ok, wait for rake task to process this file'
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
    market_ids
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
      company_locations_attributes: [:location_id, :_destroy],
      :market_ids => []
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
    @company_params ||= allowed_company
      .merge(
        ensure_location(params.require(:company).permit(company_locations_attributes: [:id, :location_id, :_destroy])))
  end

  def ensure_location( location )
    check_id = ->(key, value ) {
      location_id = value["location_id"]

      t = JSON.parse(location['company_locations_attributes'][key]["location_id"]);

      if t.is_a?(Fixnum) 
        location['company_locations_attributes'][key]["location_id"] = t
        return
      end
      if t
        t = t["terms"].reverse
        country = t[0]["value"]
        state   = t[1]["value"]
        city    = t[2]["value"]

        loc = Location.where( country: country, city: city ).first

        if loc 
          location['company_locations_attributes'][key]["location_id"] = loc.id
        else
          loc = Location.new( country: country, city: city, region: state )
          loc.save
          location['company_locations_attributes'][key]["location_id"] = loc.id
        end
      else
        location['company_locations_attributes'][key]["location_id"] = 0
      end

      value
    }

    ids = location['company_locations_attributes'].each(&check_id)
    location
  end

  def allowed_company
    COMPANY_PARAMS.inject({}) do |acc, param|
      print " => ", param, "\n"
      if param == :company_locations_attributes 
        acc.merge(param => ensure_location(alloweds[param].presence)) 
      else
        acc.merge(param => alloweds[param].presence)
      end
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

  def delete_investor(company)
    company.investor.delete if company.investor.present?
  end

  def only_admin_or_moderator!
    return if [User::ADMIN, User::MODERATOR].include?(current_user&.role)

    flash[:error] = 'Unauthorized'
    redirect_to root_path
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
