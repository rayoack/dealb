class CompanySearcher
  def initialize(filter_params, domain_country_context)
    @filter_params = filter_params
    @domain_country_context = domain_country_context
    @filter = Company
  end

  def call
    filter_by_domain_country_context
    filter_by_params
    sort_by_name

    @filter
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
    name: :filter_by_column,
    description: :filter_by_column,
    status: :filter_by_column,
    employees_count: :filter_by_number,
    location: :filter_by_location
  }.with_indifferent_access.freeze

  def filter_by_domain_country_context
    @filter = @filter.where(domain_country_context: domain_country_context)
  end

  def filter_by_params
    Hash(filter_params).each_value do |filter|
      name = filter.values[0].downcase.tr(' ', '_')
      operator = filter.values[1].downcase.tr(' ', '_')
      value = filter.values[2]
      filter_name = FILTERS.fetch(name, 'bypass')

      method(filter_name)
        .call(name, OPERATORS.fetch(operator), value)
    end
  end

  def filter_by_column(name, operator, value)
    @filter = @filter.where(
      "#{name} #{operator} ?",
      format(operator, value)
    )
  end

  def filter_by_number(name, operator, value)
    filter_by_column(name, operator, value.gsub(/[^\d]+/, '').to_i)
  end

  def filter_by_location(_name, operator, value)
    @filter = @filter.joins(:locations).where(
      "locations.city #{operator} :value OR " \
      "locations.country #{operator} :value",
      value: format(operator, value)
    )
  end

  def bypass(name, _operator, _value)
    Rails.logger.info("unknown filter by name '#{name}'")
  end

  def format(operator, value)
    return "%#{value}%" if operator == 'ILIKE'

    value
  end

  def sort_by_name
    @filter = @filter.order(name: :asc)
  end
end
