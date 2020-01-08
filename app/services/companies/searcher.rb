module Companies
  # Company Searcher Service
  class Searcher < ::BaseSearcher
    def initialize(filter_params, domain_country_context)
      super(filter_params, domain_country_context)

      @filter = Company
      # preload para agilizar load e melhorar ordenacao
      # @filter = @filter.preload(:locations, :deals)
      @filter = @filter.preload(:deals, company_locations: :location)
      @filter = @filter.group(:id).joins(:deals)
    end

    def call
      filter_by_domain_country_context
      filter_by_params

      @filter.order(order_criteria)
    end

    private

    def filters
      {
        name: :filter_by_column,
        description: :filter_by_column,
        status: :filter_by_column,
        employees_count: :filter_by_number,
        location: :filter_by_location,
        rounds_count: :filter_by_rounds,
        funds_raised: :filter_by_funds,
        tag: :filter_by_tag,
        funding_type: :filter_by_funding_type
      }
    end

    def filter_by_column(name, operator, value)
      @filter = @filter.where(  
        "companies.#{name} #{operator} (?)",
        format(operator, value)
      )
    end

    def filter_by_location(_name, operator, value)
      @filter = @filter.joins(:location).where(
        "locations.city #{operator} (:value) OR " \
        "locations.country #{operator} (:value) OR "\
        "locations.city || ', ' || locations.country #{operator} (:value) ",
        value: format(operator, value)
      )
    end

    def filter_by_rounds(_name, operator, value)
      @filter = @filter.joins(:deals)
                       .having("COUNT(*) #{operator} ?", value)
                       .group(:id)
    end

    def filter_by_funds(_name, operator, value)
      @filter = @filter.joins(:deals)
                       .having("SUM(amount_dolar) #{operator} #{value}")
                       .group(:id)
    end

    def filter_by_tag(_name, operator, value)
      @filter = @filter.joins(:markets)
                       .where("markets.name #{operator} (?)", value)
                       .group(:id)
    end

    def filter_by_funding_type(_name, operator, value)
      @filter = @filter.joins(:deals)
                       .where("deals.round #{operator} (?)", value)
                       .group(:id)
    end

    def format(operator, value)
      return "%#{value}%" if operator == 'ILIKE'

      value
    end

    def order_criteria
      return { name: :asc } if order_direction.blank? || order_type.blank?
      return "sum(coalesce(deals.amount_dolar,0)) #{order_direction}" if order_type == :funds_raised
  
      { order_type => order_direction }
    end

    def order_direction
      @order_direction ||= filter_params.fetch('order', nil)
    end
  
    def order_type
      @order_type ||= filter_params.fetch('type', nil)&.to_sym
    end
  end
end
