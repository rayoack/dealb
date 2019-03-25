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
              .group(:id, :amount_currency)
              .order(order_criteria)
              .preload(:investable)
              .select(:id,
                      :investable_type,
                      :investable_id,
                      :amount_currency)
              .select(invested_capital_selection)
              .select('COUNT(deals.id) as deals_count')
    end

    private

    attr_reader :options

    def order_criteria
      order = options[:order]&.to_sym

      return 'deals_count DESC' if order == :deals
      return 'invested_capital DESC' if order == :capital

      order.presence || { id: :asc }
    end

    def invested_capital_selection
      'SUM(CASE WHEN amount_cents = NULL THEN 0 ELSE amount_cents END) ' \
      'as invested_capital'
    end
  end
end
