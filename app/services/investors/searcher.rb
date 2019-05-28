module Investors
  class Searcher
    def initialize(filter_params, domain_country_context)
      @filter_params = filter_params
      @domain_country_context = domain_country_context
      @filter = Investor
    end

    def call
      filter_by_domain_country_context
      filter_by_params

      @filter.order(order_criteria)
    end

    private

    attr_reader :filter_params, :domain_country_context

    OPERATORS = {
      equal: '=',
      contains: 'ILIKE',
      greater_than: '>=',
      less_than: '<='
    }.with_indifferent_access.freeze
    private_constant :OPERATORS

    FILTERS = {
      status: :filter_by_column,
      tag: :filter_by_column,
      stage: :filter_by_column,
      number_of_deals: :filter_by_number_of_deals,
      total_funds_invested: :filter_by_total_funds_invested
    }.with_indifferent_access.freeze

    def filter_by_domain_country_context
      @filter = @filter.where(domain_country_context: domain_country_context)
    end

    def filter_by_params
      Hash(filter_params).each_value do |filter|
        next if filter.is_a?(String)

        name = filter.values[0].downcase.tr(' ', '_')
        operator = filter.values[1].downcase.tr(' ', '_')
        value = filter.values[2]
        filter_name = FILTERS.fetch(name, 'bypass')

        method(filter_name).call(name, OPERATORS.fetch(operator), value)
      end
    end

    def filter_by_column(name, operator, value)
      @filter = @filter.where("#{name} #{operator} ?", format(operator, value))
    end

    def filter_by_number_of_deals(_name, operator, value)
      @filter = @filter.joins(:deal_investors)
                       .group('investors.id')
                       .having("COUNT(investor_id) #{operator} ?", format(operator, value))
    end

    def filter_by_total_funds_invested(_name, operator, value)
      parsed_value = value.gsub(/[^\d]+/, '').to_i * 100

      @filter = @filter.joins(:deals)
                       .group('investors.id')
                       .having("SUM(amount_cents) #{operator} ?",
                               format(operator, parsed_value))
    end

    def bypass(name, _operator, _value)
      Rails.logger.info("unknown filter by name '#{name}'")
    end

    def format(operator, value)
      return "%#{value}%" if operator == 'ILIKE'

      value
    end

    def order_criteria
      return { type => order } if order_direction.present? && order_type.present?

      { created_at: :asc }
    end

    def order_direction
      @order_direction ||= filter_params.fetch('order', nil)
    end

    def order_type
      @order_type ||= filter_params.fetch('type', nil)&.to_sym
    end
  end
end
