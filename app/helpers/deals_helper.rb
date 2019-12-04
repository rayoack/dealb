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
    puts 'Exchange rates init'
    puts deal.close_date
    date = deal.close_date.strftime('%Y-%m-%d')
    dolar_rate = JSON.parse(
      # https://api.exchangeratesapi.io/2016-04-09?&base=USD&symbols=BRL
      Faraday.get("https://api.exchangeratesapi.io/#{date}", {base: 'USD', symbols: 'BRL'}).body
    ).fetch('rates')
    .fetch('BRL')

    # puts dolar_rate
    # sprintf("%0.010f", dolar_rate)
  end

  def amount_dolar(deal)
    rates = exchange_rates(deal)
    puts rates
    puts sprintf("%0.010f", rates)
    if deal.amount_currency == 'USD' then
      deal.amount
    else
      deal.amount * (1 / rates)
    end
  end

  def amount_real(deal)
    rates = exchange_rates(deal)
    if deal.amount_currency == 'BRL' then
      deal.amount
    else
      deal.amount * rates
    end
  end
end
