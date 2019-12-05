require "#{Rails.root}/app/helpers/deals_helper"
include DealsHelper

namespace :currency do
  desc "convert values to dollar in exchange rate of clode date"
  task exchange_rate: :environment do
    Deal.find_each do |deal|
      convert_to_dolar(deal)
    end
  end
end
