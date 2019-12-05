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
    JSON.parse(
      # https://api.exchangeratesapi.io/2016-04-09?&base=USD&symbols=BRL
      Faraday.get("https://api.exchangeratesapi.io/#{date}", base: 'USD', symbols: 'BRL').body
    ).fetch('rates')
    .fetch('BRL')
  end

  def convert_to_dolar(deal)
    begin
      rates = exchange_rates(deal.close_date)
      deal.exchange_rates = rates
      deal.pre_valuation_dolar =
        if deal.pre_valuation_currency.present?
          if deal.pre_valuation_currency != 'USD'
            deal.pre_valuation * (1 / rates)
          else
            deal.pre_valuation
          end
        else
          nil
        end
      deal.amount_dolar =
        if deal.amount_currency.present?
          if deal.amount_currency != 'USD'
            deal.amount * (1 / rates)
          else
            deal.amount
          end
        else
          nil
        end
      deal.save
    rescue
      nil
    end
  end
end
