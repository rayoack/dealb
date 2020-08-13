# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV.fetch('DEALBOOK_DOMAIN_N') { 'https://dealbook.co' }

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
    Company.find_each do |company|
      add "/companies/#{company.permalink}", :lastmod => company.updated_at
    end

    Deal.find_each do |deal|
      add "/deals/#{deal.id}", :lastmod => deal.updated_at
    end

    Person.find_each do |person|
      add "/people/#{person.permalink}", :lastmod => person.updated_at
    end
    
    Investor.find_each do |investor|
      add "/investors/#{investor.permalink}", :lastmod => investor.updated_at
    end
end
