# frozen_string_literal: true

module DealsHelper
  def investors_link(deal)
    return if deal.investors.blank?

    deal.investors.map do |investor|
      if investor.investable_type == 'Company'
        link_to(investor.name, "/companies/#{investor.investable.permalink}")
      elsif investor.investable_type == 'Person'
        link_to(investor.name, "/people/#{investor.investable.permalink}")
      end
    end.join('/ ').html_safe # rubocop:disable Rails/OutputSafety
  end

  def exchange_rates(date)
    date = date.strftime('%Y-%m-%d')
    dolar_rate = JSON.parse(
      # https://api.exchangeratesapi.io/2016-04-09?&base=USD&symbols=BRL
      Faraday.get("https://api.exchangeratesapi.io/#{date}", { base: 'USD', symbols: 'BRL' }).body
    ).fetch('rates')
    .fetch('BRL')
    return dolar_rate
  end

  def convert_to_dolar(deal)
    rates = exchange_rates(deal.close_date)
    deal.exchange_rates = rates
    if deal.pre_valuation_currency != 'USD'
      deal.pre_valuation_dolar = deal.pre_valuation * (1 / rates)
    else
      deal.pre_valuation_dolar = deal.pre_valuation
    end
    if deal.amount_currency != 'USD'
      deal.amount_dolar = deal.amount * (1 / rates)
    else
      deal.amount_dolar = deal.amount
    end
    deal.save
  end
end
