# frozen_string_literal: true

class Location < ApplicationRecord
  validates :country, :city, presence: true

  has_many :localizables, dependent: :destroy

  # Methods
  def full
    return "" if !self.city.present? && !self.country.present?
    "#{self.city}, #{self.region}, #{self.country}"
  end
end
