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

  # Hooks
  before_validation do
    unless permalink
      self.permalink = name.parameterize if name.presence
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

    {
      avatar: information[:avatar],
      bio: information[:bio],
      facebook_url: URLS[:facebook] + data[:facebook][:handle],
      twitter_url: URLS[:twitter] + data[:twitter][:handle],
      linkedin_url: URLS[:linkedin] + data[:linkedin][:handle],
      clearbit_syncronized_at: Time.zone.now
    }
  end
end
