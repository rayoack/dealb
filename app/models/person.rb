# frozen_string_literal: true

class Person < ApplicationRecord
  include Social

  GENDERS = [MALE = 'male', FEMALE = 'female'].freeze

  # Validations
  validates :first_name, :permalink, presence: true
  validates :permalink, slug: true, allow_nil: true
  validates :permalink, uniqueness: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :email, email: true, allow_nil: true

  validates :website_url, url: true, allow_nil: true
  validates :facebook_url, url: true, allow_nil: true
  validates :twitter_url, url: true, allow_nil: true
  validates :google_plus_url, url: true, allow_nil: true
  validates :linkedin_url, url: true, allow_nil: true

  # Relations
  has_many :person_companies, dependent: :destroy
  has_many :company, through: :person_companies

  has_many :person_locations, dependent: :destroy
  has_many :location, through: :person_locations
  
  has_many :users, dependent: :nullify
  has_one :investor, as: :investable, dependent: :destroy

  has_many :localizables, dependent: :destroy

  # Nested
  accepts_nested_attributes_for :person_companies, allow_destroy: true
  accepts_nested_attributes_for :person_locations, allow_destroy: true

  alias_attribute :description, :bio
  alias_attribute :born_date, :born_on

  # Hooks
  before_validation do
    unless permalink
      self.permalink = name.parameterize if name.presence
    end
  end

  def self.attributes_from_clearbit(data)
    info = []

    info << [:first_name, data.dig(:name, :givenName)]
    info << [:last_name, data.dig(:name, :familyName)]
    info << [:profile_image_url, data.dig(:avatar)]
    info << [:bio, data.dig(:bio)]
    info << [:occupation, data.dig(:employment, :title)]
    info << [:website_url, data.dig(:site)] if data.dig(:site)
    info << [:facebook_url, URLS[:facebook] + data.dig(:facebook, :handle).to_s]
    info << [:twitter_url, URLS[:twitter] + data.dig(:twitter, :handle).to_s]
    info << [:linkedin_url, URLS[:linkedin] + data.dig(:linkedin, :handle).to_s]

    Hash[info]
  end

  def name
    [first_name, last_name].join(' ').strip
  end

  def country
    locations.first&.country
  end

  def locations_plain
    person_locations.includes(:location).pluck(:city, :country).map { |c| c.join(', ') }.join(' / ')
  end

  def investor?
    investor.present?
  end
end
