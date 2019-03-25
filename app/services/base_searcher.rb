# Base Searcher Service
class BaseSearcher
  def initialize(filter_params, domain_country_context)
    @filter_params = filter_params
    @domain_country_context = domain_country_context
  end

  protected

  attr_reader :filter_params, :domain_country_context

  OPERATORS = {
    equal: '=',
    contains: 'ILIKE',
    greater_than: '>=',
    less_than: '<='
  }.with_indifferent_access.freeze

  def filter_by_domain_country_context
    @filter = @filter.where(domain_country_context: domain_country_context)
  end

  def filter_by_number(name, operator, value)
    new_value = value.is_a?(Numeric) ? value : value.gsub(/[^\d]+/, '').to_i
    filter_by_column(name, operator, new_value)
  end

  def bypass(name, _operator, _value)
    Rails.logger.info("unknown filter by name '#{name}'")
  end
end
