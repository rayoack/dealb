# frozen_string_literal: true

class Person < ApplicationRecord
  GENDERS = [MALE = 'male', FEMALE = 'female'].freeze
  URLS = {
    facebook: 'https://facebook.com/',
    linkedin: 'https://linkedin.com/',
    twitter: 'https://twitter.com/'
  }.freeze

  # Validations
  validates :first_name, :permalink, presence: true
  validates :permalink, slug: true, allow_nil: true
  validates :permalink, uniqueness: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :email, email: true, allow_nil: true
  validates :email, uniqueness: true, allow_nil: true

  validates :website_url, url: true, allow_nil: true
  validates :facebook_url, url: true, allow_nil: true
  validates :twitter_url, twitter: { format: :url }, allow_nil: true
  validates :google_plus_url, url: true, allow_nil: true
  validates :linkedin_url, url: true, allow_nil: true

  # Relations
  has_many :person_companies, dependent: :destroy
  has_many(
    :localizables,
    as: :localizable, dependent: :destroy, inverse_of: :localizables
  )
  has_many :locations, through: :localizables
  has_many :users, dependent: :nullify
  has_one :investor, as: :investable, dependent: :destroy

  # Nested
  accepts_nested_attributes_for :person_companies
  accepts_nested_attributes_for :locations

  alias_attribute :description, :bio
  alias_attribute :born_date, :born_on

  # Hooks
  before_validation do
    unless permalink
      self.permalink = name.parameterize if name.presence
    end
  end

  before_save do
    # Sync with clearbit info
    if clearbit_syncronized_at.blank? && Rails.env.production?
      new_attributes = Person.attributes_from_clearbit(email: email)
      updated_attributes = attributes.reject { |_, v| v.nil? }
                                     .reverse_merge(new_attributes)
      assign_attributes(updated_attributes)
    end
  end

  def name
    [first_name, last_name].join(' ').strip
  end

  def self.attributes_from_clearbit(email: nil, data: nil)
    return if email.blank? && data.blank?

    information = data
    information ||= Clearbit::Enrichment::Person.find(email: email,
                                                      stream: true)
    information = information&.deep_symbolize_keys

    {
      profile_image_url: information.dig(:avatar),
      bio: information.dig(:bio),
      facebook_url: URLS[:facebook] + information.dig(:facebook, :handle).to_s,
      twitter_url: URLS[:twitter] + information.dig(:twitter, :handle).to_s,
      linkedin_url: URLS[:linkedin] + information.dig(:linkedin, :handle).to_s,
      clearbit_syncronized_at: Time.zone.now
    }
  end
end
