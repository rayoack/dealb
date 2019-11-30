# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportCompany
    def run
      puts '-- company'
      ImportOldDatabaseService::Entities::Company.find_each do |company|
        printf('.')
        @company = company
        ::Company.create!(
          name: company.name.presence,
          description: company.description.presence,
          homepage_url: normalize(company.website),
          linkedin_url: normalize(company.linkedin),
          status: company.status.presence || ::Company::ACTIVE,
          created_at: company.created_at.presence,
          updated_at: company.updated_at.presence,
          permalink: company.slug.presence.parameterize || nil
        )
      end
      puts "-- imported #{::Company.count} companies"
    end
    private
    def normalize(url)
      ActiveSupport::Inflector.transliterate(
        String(
          url.presence.try(:downcase).try(:strip)
        )
      ).presence
    end
  end
end
