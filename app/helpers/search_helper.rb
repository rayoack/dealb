module SearchHelper
  def search_table_ref(resource)
    return "/people/#{resource.permalink}" if resource.is_a? Person
    return "/investor/#{resource.permalink}" if resource.is_a? Investor
    return "/deals/#{resource.id}" if resource.is_a? Deal
    return "/companies/#{resource.permalink}" if resource.is_a? Company

    '/search'
  end
end
