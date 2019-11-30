module Companies
  # Company Searcher Service
  class Searcher < ::BaseSearcher
    def initialize(filter_params, domain_country_context)
      super(filter_params, domain_country_context)

      @filter = Company
      # preload para agilizar load e melhorar ordenacao
      @filter = @filter.preload(:locations, :deals)
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
        tag: :filter_by_tag
      }
    end

    def filter_by_column(name, operator, value)
      @filter = @filter.where(
        "companies.#{name} #{operator} ?",
        format(operator, value)
      )
    end

    def filter_by_location(_name, operator, value)
      @filter = @filter.joins(:locations).where(
        "locations.city #{operator} :value OR " \
        "locations.country #{operator} :value",
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
                       .having("SUM(amount) #{operator} #{value}")
                       .group(:id)
    end

    def filter_by_tag(_name, operator, value)
      @filter = @filter.joins(:tags)
                       .where("tags.name #{operator} ?", value)
                       .group(:id)
    end

    def format(operator, value)
      return "%#{value}%" if operator == 'ILIKE'

      value
    end

    def order_criteria
      order = filter_params.fetch('order', nil)
      type = filter_params.fetch('type', nil)&.to_sym

      return { type => order } if order.present? && type.present?

      { name: :asc }
    end
  end
end
