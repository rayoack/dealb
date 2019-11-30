# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportCompanyLocation
    # rubocop:disable Metrics/MethodLength
    def run
      puts '-- company location'
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
        ::Localizable.create!(location: new_location, localizable: new_company)
      end
      puts "-- imported #{::Localizable.count} companies locations"
    end
    # rubocop:enable Metrics/MethodLength
  end
end
