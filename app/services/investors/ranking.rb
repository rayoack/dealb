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
              .preload(:investable)
              .where(deals: { category: :raised_funds_from })
              .where.not(deals: { amount_cents: nil })
              .group(:id, :amount_currency)
              .order(order_criteria)
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
      type = options[:type]&.to_sym

      return "deals_count #{order}" if type == :deals
      return "invested_capital #{order}" if type == :capital

      type.presence || { id: :asc }
    end

    def invested_capital_selection
      'SUM(CASE WHEN amount_cents = NULL THEN 0 ELSE (amount_cents/100) END) ' \
      'as invested_capital'
    end

    def order
      options.dig(:order)&.to_s&.upcase || 'DESC'
    end
  end
end
