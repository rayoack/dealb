module Investors
  class Searcher < ::BaseSearcher
    def initialize(filter_params, domain_country_context)
      #super(filter_params, domain_country_context)
      @filter_params = filter_params
      @domain_country_context = domain_country_context
      @filter = Investor
    end

    def call
      filter_by_domain_country_context
      filter_by_params
      @filter = @filter.left_outer_joins(:deals)
        .preload(:investable)
        .group(:id)
        .order(order_criteria)
        .select(:id,
          :investable_type,
          :investable_id,
          :tag)
        .select('COUNT(investor_id) as number_of_deals')
    end

    private

    attr_reader :filter_params, :domain_country_context

    OPERATORS = {
      equal: '=',
      contains: 'ILIKE',
      greater_than: '>=',
      less_than: '<='
    }.with_indifferent_access.freeze

    def filters
      {
        status: :filter_by_status,
        tag: :filter_by_column,
        stage: :filter_by_column,
        number_of_deals: :filter_by_number_of_deals,
        total_funds_invested: :filter_by_total_funds_invested,
        name: :filter_by_name,
        location: :filter_by_location
      }
    end

    def filter_by_location(_name, operator, value)
      @filter = @filter
        .joins(" LEFT JOIN companies ON companies.id = investors.investable_id AND investors.investable_type = 'Company'")
        .joins(" LEFT JOIN people ON people.id = investors.investable_id AND investors.investable_type = 'Person'")
        .joins(" LEFT JOIN company_locations ON companies.id = company_locations.company_id")
        .joins(" LEFT JOIN person_locations ON people.id = person_locations.person_id")
        .joins(" LEFT JOIN locations ON locations.id = person_locations.location_id OR locations.id = company_locations.location_id")
        .where("locations.city || ', ' || locations.country #{operator} (:value) ",
          value: format(operator, value))
    end

    def filter_by_domain_country_context
      @filter = @filter.where(domain_country_context: domain_country_context)
    end

    def filter_by_column(name, operator, value)
      @filter = @filter.where(
        "#{name} #{operator} (?)",
        format(operator, value)
      )
    end

    def filter_by_status(name, operator, value)
      @filter = @filter.where("investors.#{name} #{operator} (?)", format(operator, value))
    end

    def filter_by_number_of_deals(_name, operator, value)
      @filter = @filter.having("COUNT(investor_id) #{operator} ?", format(operator, value))
    end

    def filter_by_total_funds_invested(_name, operator, value)
      parsed_value = value.gsub(/[^\d]+/, '').to_i

      @filter = @filter.left_outer_joins(:deals)
                       .group('investors.id')
                       .having("SUM(amount) #{operator} ?",
                               format(operator, parsed_value))
    end

    def filter_by_name(name, operator, value)
      @filter = @filter
        .joins(" LEFT JOIN companies ON companies.id = investors.investable_id AND investors.investable_type = 'Company'")
        .joins(" LEFT JOIN people ON people.id = investors.investable_id AND investors.investable_type = 'Person'")
        .where("(companies.name #{operator} ? OR people.first_name #{operator} ? OR people.last_name #{operator} ?)",
          format(operator, value),
          format(operator, value),
          format(operator, value))
    end

    def bypass(name, _operator, _value)
      Rails.logger.info("unknown filter by name '#{name}'")
    end

    def format(operator, value)
      return "%#{value}%" if operator == 'ILIKE'

      value
    end

    def order_criteria
      return { created_at: :desc } if order_direction.blank? || order_type.blank?
      return "number_of_deals #{order_direction}" if order_type == :number_of_deals
      
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
