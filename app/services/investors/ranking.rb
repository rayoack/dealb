module Investors
  class Ranking
    def initialize(options = {})
      @options = options
    end

    def call
      call!
    rescue PG::UndefinedColumn
      nil
    end

    def call!
      Investor.active
              .joins(:deals)
              .select(:investable_type, :investable_id, :amount_currency)
              .select('SUM(amount_cents) as invested_capital')
              .group(:id, :amount_currency)
              .preload(:investable)
              .order(options[:order])
    end

    private

    attr_reader :options
  end
end
