# Person Searcher Service
class PersonSearcher < BaseSearcher
  def initialize(filter_params, domain_country_context)
    super(filter_params, domain_country_context)
    @filter = Person
    # preload para acelerar load das pessoas
    @filter = @filter.preload(:locations, person_companies: :company)
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

  def filters
    {
      name: :filter_by_name,
      bio: :filter_by_column,
      gender: :filter_by_column,
      occupation: :filter_by_column
    }
  end

  def filter_by_domain_country_context
    @filter = @filter.where(domain_country_context: domain_country_context)
  end

  def filter_by_name(_name, operator, value)
    @filter = @filter.where(
      "first_name #{operator} :value OR " \
      "last_name #{operator} :value OR " \
      "CONCAT(first_name, ' ', last_name) #{operator} :value",
      value: format(operator, value)
    )
  end

  def filter_by_column(name, operator, value)
    @filter = @filter.where(
      "#{name} #{operator} ?",
      format(operator, value)
    )
  end

  def bypass(name, _operator, _value)
    Rails.logger.info("unknown filter by name '#{name}'")
  end

  def format(operator, value)
    return "%#{value}%" if operator == 'ILIKE'

    value
  end

  def order_criteria
    return { created_at: :asc } if order_direction.blank? || order_type.blank?

    { order_type => order_direction }
  end

  def order_direction
    @order_direction ||= filter_params.fetch('order', nil)
  end

  def order_type
    @order_type ||= filter_params.fetch('type', nil)&.to_sym
  end
end
