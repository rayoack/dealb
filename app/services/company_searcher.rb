# Company Searcher Service
class CompanySearcher < BaseSearcher
  def initialize(filter_params, domain_country_context)
    super(filter_params, domain_country_context)
    @filter = Company
  end

  def call
    filter_by_domain_country_context
    filter_by_params
    sort_by_name

    @filter
  end

  private

  FILTERS = {
    name: :filter_by_column,
    description: :filter_by_column,
    status: :filter_by_column,
    employees_count: :filter_by_number,
    location: :filter_by_location,
    rounds_count: :filter_by_rounds
  }.with_indifferent_access.freeze

  def filter_by_params
    Hash(filter_params).each_value do |filter|
      name = filter['type'].downcase.tr(' ', '_')
      operator = filter['operator'].downcase.tr(' ', '_')
      value = filter['value']
      filter_name = FILTERS.fetch(name, 'bypass')

      method(filter_name)
        .call(name, OPERATORS.fetch(operator), value)
    end
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

  def format(operator, value)
    return "%#{value}%" if operator == 'ILIKE'

    value
  end

  def sort_by_name
    @filter = @filter.order(name: :asc)
  end
end
