# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportCompanyLocation
    # rubocop:disable Metrics/MethodLength
    def run
      ImportOldDatabaseService::Entities::CompanyLocation
        .all
        .each do |company_location|

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
      rescue StandardError => e
        Rails.logger.debug(e)
      end

      warn "\nImported companies_locations - final statistics"

      # rubocop:disable Metrics/LineLength
      warn(
        "old_count: #{::ImportOldDatabaseService::Entities::CompanyLocation.count} " \
        "new_count: #{::Localizable.count} companies_locations"
      )
      # rubocop:enable Metrics/LineLength
    end
    # rubocop:enable Metrics/MethodLength
  end
end
