# Deals Searcher Service
class DealSearcher < BaseSearcher
  def initialize(filter_params, domain_country_context)
    super(filter_params, domain_country_context)
    @filter = Deal
    # preload para agilizar load e melhorar ordenacao
    @filter = @filter.preload(:investors, :deal_investors, :company, investors: :investable)
    # @filter = @filter.includes(investors: :investable)
  end

  def call
    filter_by_domain_country_context
    filter_by_params
    sorted_deals
  end

  private

  def filters
    {
      status: :filter_by_column,
      category: :filter_by_column,
      funding_type: :filter_by_funding_type,
      amount: :filter_by_amount,
      date: :filter_by_date
    }.with_indifferent_access
  end

  def filter_by_column(name, operator, value)
    @filter = @filter.where(
      "#{name} #{operator} ?",
      format(operator, value)
    )
  end

  def filter_by_amount(_name, operator, value)
    filter_by_number(:amount, operator, value.to_f)
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
    return "coalesce(deals.#{order_type}, 0) #{order_direction}" if order_type == :amount

    { order_type => order_direction }
  end

  def order_direction
    @order_direction ||= filter_params.fetch('order', nil)
  end

  def order_type
    @order_type ||= filter_params.fetch('type', nil)&.to_sym
  end
end
