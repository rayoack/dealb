# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportDeal
    ROUNDS = {
      'Acceleration' => Deal::ACCELERATION,
      'Seed' => Deal::SEED,
      'Series Seed' => Deal::SERIES_SEED,
      'Series A' => Deal::SERIES_A,
      'Series B' => Deal::SERIES_B,
      'Series C' => Deal::SERIES_C,
      'Series D' => Deal::SERIES_D,
      'Series E' => Deal::SERIES_E,
      'IPO' => Deal::IPO,
      nil => nil
    }.freeze

    ACCESS_KEY = ENV['FIXER_IO_API_KEY']

    def run
      ImportOldDatabaseService::Entities::Deal.find_each do |deal|
        printf('.')

        ::Deal.create!(close_date: deal.close_date,
                       company_id: company(deal).id,
                       status: status(deal),
                       category: category(deal),
                       round: round(deal),
                       amount_currency: ::Deal::USD,
                       amount_cents: amount_cents(deal),
                       pre_valuation_currency: ::Deal::USD,
                       pre_valuation_cents: pre_valuation_cents(deal),
                       source_url: source_url(deal))
      end

      warn "\nImported deal - final statistics"
      warn "count: #{::Deal.count} deals"
    end

    private

    def company(deal)
      company_name = ImportOldDatabaseService::Entities::Company
        .find(deal.company_id)
        .name

      ::Company.find_by!(name: company_name)
    end

    def status(deal)
      deal.verified ? ::Deal::VERIFIED : ::Deal::UNVERIFIED
    end

    def category(deal)
      if deal.category == 'shut down'
        ::Deal::SHUTDOWN
      else
        deal.category.tr(' ', '_')
      end
    end

    def round(deal)
      ROUNDS.fetch(deal.round.presence)
    end

    def amount_cents(deal)
      if deal.currency.blank? || deal.amount.nil? # nil ou ""
        @amount_value_cents = nil # don't touch

      elsif deal.currency == 'BRL'
        convert_to_usd(deal)

      elsif deal.currency == 'USD'
        (deal.amount * 100).to_i
      else
        raise 'deu ruim'
      end
    end

    def pre_valuation_cents(deal)
      return if deal.currency.blank? || deal.amount.nil? # nil ou ""
      return unless deal.pre_valuation

      if deal.currency == 'BRL'
        # TODO: preciso ver o que fazer nesse caso aqui com o Diego
        dolar_quote = 3.5

        return ((deal.pre_valuation * dolar_quote) * 100).to_i
      elsif deal.currency == 'USD'
        @amount_value_cents = (deal.amount * 100).to_i

        return (deal.pre_valuation * 100).to_i
      else
        raise 'deu ruim'
      end
    end

    def source_url(deal)
      return unless deal.source_url.presence

      deal.source_url.presence.delete(' ').strip
    end

    def convert_to_usd_from(deal, curency)
      date = deal.close_date.strftime('%Y-%m-%d')
      dolar_rate = JSON.parse(
        Faraday.get(
          "https://exchangeratesapi.io/api/#{date}?base=#{currency}&symbols=USD"
        ).body
      ).fetch('rates').fetch('USD')
      ((deal.amount * dolar_rate) * 100).to_i
    end

    def convert_to_usd(deal)
      date = deal.close_date.strftime('%Y-%m-%d')

      dolar_rate = JSON.parse(
        Faraday.get(
          "https://exchangeratesapi.io/api/#{date}?&base=USD&symbols=USD"
        ).body
      ).fetch('rates').fetch('USD')

      ((deal.amount * dolar_rate) * 100).to_i
    end
  end
end
