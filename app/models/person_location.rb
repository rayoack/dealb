class PersonLocation < ApplicationRecord
  # Validations
  validates :person, :location, presence: true
  
  # Relations
  belongs_to :person
  belongs_to :location
end
