# Deals Searcher Service
class DealSearcher < BaseSearcher
  def initialize(filter_params, domain_country_context)
    super(filter_params, domain_country_context)
    @filter = Deal
  end

  def call
    filter_by_domain_country_context
    filter_by_params
    sorted_deals
  end

  private

  FILTERS = {
    status: :filter_by_column,
    category: :filter_by_column,
    funding_type: :filter_by_funding_type,
    amount: :filter_by_amount,
    date: :filter_by_date
  }.with_indifferent_access.freeze

  def filter_by_params
    Hash(filter_params).each_value do |filter|
      next if filter.is_a?(String)

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
      "#{name} #{operator} ?",
      format(operator, value)
    )
  end

  def filter_by_amount(_name, operator, value)
    filter_by_number(:amount_cents, operator, value.to_f * 100)
  end

  def filter_by_funding_type(_name, operator, value)
    filter_by_column(:round, operator, value)
  end

  def filter_by_date(_name, operator, value)
    filter_by_column('CAST(close_date AS VARCHAR)', operator, value)
  end

  def format(operator, value)
    return "%#{value}%" if operator == 'ILIKE'

    value
  end

  def sorted_deals
    @filter = @filter.joins(:company) if order_type == :name

    @filter.order(order_criteria)
  end

  def order_criteria
    return { close_date: :desc } if order_direction.blank? || order_type.blank?
    return "companies.#{order_type} #{order_direction}" if order_type == :name

    { order_type => order_direction }
  end

  def order_direction
    @order_direction ||= filter_params.fetch('order', nil)
  end

  def order_type
    @order_type ||= filter_params.fetch('type', nil)&.to_sym
  end
end
