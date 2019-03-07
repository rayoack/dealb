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
  validates :twitter_url, twitter: { format: :url }, allow_nil: true
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
  before_validation :populate_from_clearbit

  private

  def populate_from_clearbit
    return unless Rails.env.production?

    domain_data = Clearbit::NameDomain.find(name: name)
    data = Clearbit::Enrichment::Company.find(domain_data.slice(:domain))
    data = data.deep_symbolize_keys

    self.name = data[:name]
    self.description = data[:description]
    self.profile_image_url = data[:logo] if profile_image_url.blank?
    self.employees_count = data.dig(:metrics, :employees)
    self.founded_on = Time.new(data[:foundedYear]) if data[:foundedYear]
    self.phone_number = data[:phone]
    self.contact_email = data.dig(:site, :emailAddresses)&.first
    self.legal_name = data[:legalName]
    self.homepage_url = 'https://' + data[:domain] if data[:domain]
    self.facebook_url = URLS[:facebook] + data.dig(:facebook, :handle)
    self.twitter_url = URLS[:twitter] + data.dig(:twitter, :handle)
    self.linkedin_url = URLS[:linkedin] + data.dig(:linkedin, :handle)
    self.crunchbase_url = URLS[:crunchbase] + data.dig(:crunchbase, :handle)
    self.stock_symbol = data[:ticker]
    self.rank = data.dig(:metrics, :alexaGlobalRank)
  end
end
