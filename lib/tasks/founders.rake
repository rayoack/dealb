require 'csv'

# rubocop:disable Metrics/BlockLength
namespace :founders do
  task import: :environment do |_task, _args|
    puts('---- Starting Founders import from CSV ----')

    CSV.foreach('./founders_to_import.csv') do |row|
      name = row.first.presence
      permalink = name&.parameterize
      website = row.second.presence
      title = row.third.presence || 'Contributor'
      org = row.fourth.presence
      org_permalink = org&.parameterize
      email = row.fifth.presence
      type = row.last.presence&.downcase

      person = find_or_create_person(email, permalink, website, name)
      company = Company.find_by(permalink: org_permalink)

      if company.present?
        relation = PersonCompany.find_or_initialize_by(person: person, company: company)
      elsif org.present?
        company = Company.create!(name: org)
        relation = PersonCompany.new(person: person, company: company)
      end

      relation&.job_title = title if relation&.job_title.blank?
      relation&.save!

      investor = Investor.find_or_create_by(investable: person)
      investor.update!(tag: type.downcase) if type.in?(Investor::TAGS)

      puts("-- Imported Investor, ID: #{investor.id}")
    end

    puts('---- Finished Founders import from CSV ----')
  end
end
# rubocop:enable Metrics/BlockLength

def find_or_create_person(email, permalink, website, name)
  person = Person.find_by(email: email)
  person ||= Person.find_by(permalink: permalink)
  person ||= Person.find_by(website_url: website)
  person ||= Person.create!(email: email,
                            first_name: name,
                            website_url: "http://#{website}")

  person
end
