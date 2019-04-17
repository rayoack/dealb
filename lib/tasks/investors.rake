require 'csv'

namespace :investors do
  task import: :environment do |_task, _args|
    puts('---- Starting Investors import from CSV ----')

    CSV.foreach('./investors_import.csv') do |row|
      email = row.last.presence
      name = row.first.presence
      permalink = name&.parameterize
      website = row.second.presence
      title = row.third.presence || 'Contributor'
      org = row.fourth.presence
      org_permalink = org&.parameterize

      person = find_or_create_person(email, permalink, website, name)
      company = Company.find_by(permalink: org_permalink)

      if company.present?
        relation = PersonCompany.find_or_initialize_by(person: person, company: company)
      else
        company = Company.create!(name: org)
        relation = PersonCompany.new(person: person, company: company)
      end

      relation.job_title = title if relation.job_title.blank?
      relation.save!

      investor = Investor.find_or_create_by(investable: person)

      puts("-- Imported Investor, ID: #{investor.id}")
    end

    puts('---- Finished Investors import from CSV ----')
  end
end

def find_or_create_person(email, permalink, website, name)
  person = Person.find_by(email: email)
  person ||= Person.find_by(permalink: permalink)
  person ||= Person.find_by(website_url: website)
  person ||= Person.create!(email: email,
                            first_name: name,
                            website_url: "http://#{website}")

  person
end
