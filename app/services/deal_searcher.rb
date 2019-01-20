class DealSearcher
  def initialize(filter_params, domain_country_context)
    @filter_params = filter_params
    @domain_country_context = domain_country_context
    @filter = Deal
  end

  def call
    filter_by_domain_country_context
    filter_by_params
    sort_by_close_date

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
    status: :filter_by_column,
    category: :filter_by_column,
    round: :filter_by_column,
    amount: :filter_by_amount,
    date: :filter_by_date
  }.with_indifferent_access.freeze

  def filter_by_domain_country_context
    @filter = @filter.where(domain_country_context: domain_country_context)
  end

  def filter_by_params
    Hash(filter_params).each_value do |filter|
      type, operator, value = filter.values
      name = type.downcase.tr(' ', '_')
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

  def filter_by_amount(_name, operator, value)
    filter_by_column(:amount_cents, operator, value)
  end

  def filter_by_date(_name, operator, value)
    filter_by_column('CAST(close_date AS VARCHAR)', operator, value)
  end

  def bypass(name, _operator, _value)
    Rails.logger.info("unknown filter by name '#{name}'")
  end

  def format(operator, value)
    return "%#{value}%" if operator == 'ILIKE'

    value
  end

  def sort_by_close_date
    @filter = @filter.order(close_date: :desc)
  end
end
