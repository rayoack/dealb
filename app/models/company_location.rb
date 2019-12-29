# frozen_string_literal: true

class CompanyLocation < ApplicationRecord
   # Validations
   validates :company, :location, presence: true
  
   # Relations
   belongs_to :company
   belongs_to :location
end
