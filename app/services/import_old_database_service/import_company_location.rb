# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportCompanyLocation
    def run
      Rails.logger.info('-- company location')
      ImportOldDatabaseService::Entities::CompanyLocation.all.each do |company_location|
        printf('.')
        old_location = ImportOldDatabaseService::Entities::Location.find(
          company_location.location_id
        )
        old_company = ImportOldDatabaseService::Entities::Company.find(
          company_location.company_id
        )
        new_location = ::Location.find_by!(
          country: old_location.country, city: old_location.city
        )
        new_company = ::Company.find_by!(name: old_company.name)
        ::CompanyLocation.create!(location: new_location, company: new_company)
      end
      Rails.logger.info("-- imported #{::Localizable.count} companies locations")
    end

    def update
      Rails.logger.info('-- update company location')
      ImportOldDatabaseService::Entities::CompanyLocation.all.each do |company_location|
        old_location = ImportOldDatabaseService::Entities::Location.find(
          company_location.location_id
        )
        old_company = ImportOldDatabaseService::Entities::Company.find(
          company_location.company_id
        )
        new_location = ::Location.find_by!(
          country: old_location.country, city: old_location.city, region: old_location.region
        )
        new_company = ::Company.find_by!(name: old_company.name)
        if !::CompanyLocation.exists?(location: new_location, company: new_company)
          ::CompanyLocation.create!(location: new_location, company: new_company)
        end
      end
      Rails.logger.info('-- end update company location')
    end
  end
end
