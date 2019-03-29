json.company do
  json.id @company.id
  json.name @company.name
  json.permalink @company.permalink
  json.description @company.description
  json.born_at @company.born_date.year
  json.location @company.locations do |location|
    json.country location.city
    json.country location.country
  end
  json.last_funding_type @last_deal&.round ? I18n.t("filters.labels.funding_type.#{@last_deal.round}") : nil
  json.last_funding_value format_amount(@last_deal&.amount_cents)
end
