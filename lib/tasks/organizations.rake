require 'csv'

namespace :organizations do
  task import: :environment do |_task, _args|
    puts('---- Starting Organization import from CSV ----')

    CSV.foreach('./organizations_import.csv') do |row|
      url = row.first.presence
      name = row.second.presence
      permalink = name&.parameterize

      org = Company.find_by(name: name)
      org ||= Company.find_by(homepage_url: url)
      org ||= Company.find_by(permalink: permalink)

      if org.blank?
        org = Company.new(name: name)
        org.homepage_url = "http://#{url}" if url.present?
        org.save!
      end

      puts("-- Imported Organization, ID: #{org.id}")
    end

    puts('---- Finished Organization import from CSV ----')
  end
end

def find_org(name, url, permalink)
  org = Company.find_by(name: name)
  org ||= Company.find_by(homepage_url: url)
  org ||= Company.find_by(permalink: permalink)

  org
end
