require "#{Rails.root}/app/helpers/deals_helper"
include DealsHelper

namespace :currency do
  desc "convert values to dollar in exchange rate of clode date"
  task exchange_rate: :environment do
    Rails.logger.info('-- currency:exchange_rate')
    # update deals set pre_valuation_currency = 'USD' where pre_valuation_currency is null;
    Deal.where('pre_valuation_currency is null').update_all(pre_valuation_currency: 'USD')
    # update deals set amount_dolar = amount where amount_currency = 'USD' and amount is not null;
    Deal.where("amount_currency = 'USD' and amount is not null").update_all('amount_dolar = amount')
    # update deals set pre_valuation_dolar = pre_valuation where pre_valuation_currency = 'USD' and pre_valuation is not null;
    Deal.where("pre_valuation_currency = 'USD' and pre_valuation is not null").update_all('pre_valuation_dolar = pre_valuation')
    # update all Deals where currency is BRL and value is not null
    Deal.where("(pre_valuation_currency = 'BRL' and pre_valuation is not null) or (amount_currency = 'BRL' and amount is not null)").find_each do |deal|
      printf('.')
      convert_to_dolar(deal)
    end
    Rails.logger.info('-- currency:exchange_rate end')
  end
end
