class Industry < ApplicationRecord
  belongs_to :industry_group
  has_many :sub_industry
end
