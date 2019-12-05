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

  def exchange_rates(deal)
    date = deal.close_date.strftime('%Y-%m-%d')
    dolar_rate = JSON.parse(
      # https://api.exchangeratesapi.io/2016-04-09?&base=USD&symbols=BRL
      Faraday.get("https://api.exchangeratesapi.io/#{date}", { base: 'USD', symbols: 'BRL' }).body
    ).fetch('rates')
    .fetch('BRL')
    return dolar_rate
  end

  def pre_valuation_dolar(deal)
    rates = exchange_rates(deal)
    if deal.pre_valuation_currency == 'USD'
      deal.pre_valuation
    else
      deal.pre_valuation * (1 / rates)
    end
  end

  def amount_dolar(deal)
    rates = exchange_rates(deal)
    if deal.amount_currency == 'USD'
      deal.amount
    else
      deal.amount * (1 / rates)
    end
  end

  def amount_real(deal)
    rates = exchange_rates(deal)
    if deal.amount_currency == 'BRL'
      deal.amount
    else
      deal.amount * rates
    end
  end
end
