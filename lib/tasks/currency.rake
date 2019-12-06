require "#{Rails.root}/app/helpers/deals_helper"
include DealsHelper

namespace :currency do
  desc "convert values to dollar in exchange rate of clode date"
  task exchange_rate: :environment do
    Rails.logger.info('-- currency:exchange_rate')
    Deal.where("(pre_valuation_currency = 'BRL' and pre_valuation is not null) or (amount_currency = 'BRL' and amount is not null)").find_each do |deal|
      printf('.')
      convert_to_dolar(deal)
    end
    Rails.logger.info('-- currency:exchange_rate end')
  end
end
