# frozen_string_literal: true

class MyDeal < ActiveRecord::Base
  self.table_name = 'deals'
end

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

    CURRENCIES = [
      'USD' => Deal::USD,
      'BRL' => Deal::BRL,
      nil => nil
    ].freeze

    # TODO, o que eh esse ENV?
    ACCESS_KEY = ENV['FIXER_IO_API_KEY']

    def run
      Rails.logger.info('-- deal')
      ImportOldDatabaseService::Entities::Deal.find_each do |deal|
        printf('.')
        ::Deal.create!(close_date: deal.close_date,
                       company_id: company(deal).id,
                       status: status(deal),
                       category: category(deal),
                       round: round(deal),
                       amount_currency: currency(deal),
                       amount_cents: amount_cents(deal),
                       # pre_valuation_currency: ::Deal::USD,
                       # pre_valuation_currency: currency(deal),
                       pre_valuation_cents: pre_valuation_cents(deal),
                       source_url: source_url(deal))
      end
      Rails.logger.info("-- imported #{::Deal.count} deals")
    end

    def update
      Rails.logger.info('-- update deal')
      # Activate only the phone
      ActiveValidators.activate(:phone)
      
      ImportOldDatabaseService::Entities::Deal.find_each do |deal|
        close_date = deal.close_date
        company_id = company(deal).id
        status = status(deal)
        category = category(deal)
        round = round(deal)
        currency = currency(deal)
        amount = amount_cents(deal)
        pre_valuation = pre_valuation_cents(deal)
        source_url = source_url(deal)
        if ::Deal.exists?(close_date: close_date, company_id: company_id)
          new_deal = ::MyDeal.find_by(
            close_date: close_date,
            company_id: company_id
          )
          if new_deal.present?
            new_deal.status = status
            new_deal.category = category
            new_deal.round = round
            new_deal.amount_currency = currency
            # new_deal.pre_valuation_currency = currency
            new_deal.amount = amount
            new_deal.pre_valuation = pre_valuation
            new_deal.save!
          end
        else
          ::MyDeal.create!(
            close_date: close_date,
            company_id: company_id,
            status: status,
            category: category,
            round: round,
            amount_currency: currency,
            # pre_valuation_currency: currency,
            amount: amount,
            pre_valuation: pre_valuation,
            source_url: source_url
          )
        end
      end
      Rails.logger.info('-- end update deal')
      # Activate only the phone
      ActiveValidators.activate(:all)
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

    def currency(deal)
      if deal.currency.present?
        currency = deal.currency
        if currency == 'BRL'
          Deal::BRL
        elsif currency == 'USD'
          Deal::USD
        else
          nil
        end
      end
    end

    def round(deal)
      ROUNDS.fetch(deal.round.presence)
    end

    def amount_cents_old(deal)
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

    def pre_valuation_cents_old(deal)
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

    # amount_cents ignore transformation to cents
    def amount_cents(deal)
      if deal.currency.blank? || deal.amount.nil? # nil ou ""
        @amount_value_cents = nil # don't touch
      else
        deal.amount.to_i
      end
    end

    # pre_valuation_cents ignore transformation to cents
    def pre_valuation_cents(deal)
      if deal.currency.blank? || deal.pre_valuation.nil? # nil ou ""
        @pre_valuation_cents = nil
      else
        deal.pre_valuation.to_i
      end
    end

    def source_url(deal)
      return unless deal.source_url.presence
      deal.source_url.presence.delete(' ').strip
    end

    def convert_to_usd(deal)
      date = deal.close_date.strftime('%Y-%m-%d')
      dolar_rate = JSON.parse(
        Faraday.get("https://exchangeratesapi.io/api/#{date}?&base=USD&symbols=USD").body
      )
      .fetch('rates')
      .fetch('USD')
      ((deal.amount * dolar_rate) * 100).to_i
    end
  end
end
