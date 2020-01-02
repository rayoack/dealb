# frozen_string_literal: true

module ApplicationHelper
  def language_flag
    if session[:language] || I18n.locale
      "flag-#{I18n.locale}.svg"
    else
      'language.svg'
    end
  end

  def format_amount(amount, currency = Deal::USD)
    unit = {
      Deal::USD => 'USD',
      Deal::BRL => 'R$'
    }.fetch(currency, currency)

    unit ||= 'USD'
    # puts amount
    # number_to_human(amount || 0.0, precision: 2)
    number_to_currency(number_to_human(amount || 0.0, precision: 2), unit: unit)
  end

  def filter_active(category)
    # puts 'FILTRO ATIVO'
    # puts category
    # puts params[:filter]
    return '' if params[:filter] == nil
    exist = params[:filter].values.select { |filter| filter[:type] == category }
    'filter-active' if exist.size > 0
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to("<i class=\"fas fa-plus\"></i>#{name}".html_safe, '#', class: "add_fields filter-clear", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
