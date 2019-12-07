# frozen_string_literal: true

class MyCompany < ActiveRecord::Base
  self.table_name = 'companies'
end

class ImportOldDatabaseService
  class ImportCompany
    def run
      Rails.logger.info('-- company')
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
      Rails.logger.info("-- imported #{::Company.count} companies")
    end

    def update
      Rails.logger.info('-- update company')
      ImportOldDatabaseService::Entities::Company.find_each do |company|
        if !::Company.exists?(name: company.name)
          ::MyCompany.create!(
            name: company.name.presence,
            description: company.description.presence,
            homepage_url: normalize(company.website),
            linkedin_url: normalize(company.linkedin),
            status: company.status.presence || ::Company::ACTIVE,
            created_at: company.created_at.presence,
            # updated_at: company.updated_at.presence,
            permalink: company.slug.presence
          )
        end
      end
      Rails.logger.info('-- end update company')
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
