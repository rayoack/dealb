require 'csv'

# rubocop:disable Metrics/BlockLength
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

  task import_original: :environment do |_task, _args|
    puts('---- Starting Organization import from Original Dealbook ----')

    file = File.open('./dealbook_one_companies.csv')
    file.each_line do |row|
      data = OpenStruct.new(eval(row)) # rubocop:disable Security/Eval

      company = Company.find_by(permalink: data.slug)
      company ||= Company.find_by(permalink: data.name.parameterize)
      company ||= Company.new

      company.update!(name: data.name,
                      description: data.description,
                      homepage_url: data.website.presence&.downcase&.strip,
                      linkedin_url: data.linkedin.presence&.downcase&.strip,
                      status: data.status.presence || 'active')

      puts("Company #{company.id} updated.")
    end

    puts('---- Finished Organization import from Original Dealbook ----')
  end
end
# rubocop:enable Metrics/BlockLength
