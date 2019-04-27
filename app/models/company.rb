# frozen_string_literal: true

class Company < ApplicationRecord
  include Social

  STATUSES = [
    ACTIVE = 'active',
    INACTIVE = 'inactive',
    ACQUIRED = 'acquired',
    MERGED = 'merged'
  ].freeze

  # Validations
  validates :name, :permalink, :status, presence: true

  validates :permalink, slug: true
  validates :status, inclusion: { in: STATUSES }

  validates(
    :employees_count, numericality: { only_integer: true }, allow_nil: true
  )

  validates :contact_email, email: true, allow_nil: true
  validates :homepage_url, url: true, allow_nil: true
  validates :linkedin_url, url: true, allow_nil: true
  validates :facebook_url, url: true, allow_nil: true
  validates :twitter_url, url: true, allow_nil: true
  validates :google_plus_url, url: true, allow_nil: true

  # Relations
  has_many :deals, dependent: :destroy
  has_many :person_companies, dependent: :destroy
  has_many(
    :localizables,
    as: :localizable, dependent: :destroy, inverse_of: :localizables
  )
  has_many :locations, through: :localizables
  has_one :investor, as: :investable, dependent: :destroy
  has_many :company_markets, dependent: :destroy
  has_many :markets, through: :company_markets
  has_many :deals, dependent: :destroy

  # Nested
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :company_markets

  alias_attribute :website_url, :homepage_url
  alias_attribute :born_date, :founded_on

  before_validation do
    unless permalink
      self.permalink = name.parameterize if name.present?
    end
  end

  def self.attributes_from_clearbit(data)
    info = []

    info << [:legal_name, data[:legalName]]
    info << [:profile_image_url, data[:logo]]
    info << [:employees_count, data.dig(:metrics, :employees)]
    info << [:phone_number, data[:phone]]
    info << [:contact_email, data.dig(:site, :emailAddresses)&.first]
    info << [:founded_on, Time.new(data[:foundedYear])] if data[:foundedYear]
    info << [:stock_symbol, data[:ticker]]
    info << [:rank, data.dig(:metrics, :alexaGlobalRank)]
    info << [:homepage_url, 'https://' + data[:domain]]
    info << [:facebook_url, URLS[:facebook] + data.dig(:facebook, :handle).to_s]
    info << [:linkedin_url, URLS[:linkedin] + data.dig(:linkedin, :handle).to_s]
    info << [:twitter_url, URLS[:twitter] + data.dig(:twitter, :handle).to_s]
    info << [:crunchbase_url, URLS[:crunchbase] + data.dig(:crunchbase,
                                                           :handle).to_s]

    Hash[info].merge(data.slice(:name, :description))
  end

  def headquarter_country
    locations.first&.country
  end

  def all_headquarters
    locations&.pluck(:city, :country)&.join(', ') || ''
  end
end
