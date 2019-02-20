json.company do
  json.id @company.id
  json.name @company.name
  json.description @company.description
  json.born_at @company.born_date
  json.location @company.locations do |location|
    json.country location.city
    json.country location.country
  end
end
