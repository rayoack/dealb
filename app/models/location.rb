# frozen_string_literal: true

class Location < ApplicationRecord
  validates :country, :city, presence: true

  has_many :localizables, dependent: :destroy

  # Methods
  def full
    "#{self.city}, #{self.country}"
  end
end
