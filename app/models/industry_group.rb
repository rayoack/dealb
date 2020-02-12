class IndustryGroup < ApplicationRecord
  belongs_to :sector
  has_many :industry
end
