# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportLocation
    def run
      Rails.logger.info('-- location')
      ImportOldDatabaseService::Entities::Location.find_each do |location|
        printf('.')
        ::Location.create!(country: location.country, city: location.city)
      end
      Rails.logger.info("-- imported #{::Location.count} locations")
    end

    def update
      Rails.logger.info('-- update location')
      ImportOldDatabaseService::Entities::Location.find_each do |location|
        if !::Location.exists?(country: location.country, city: location.city)
          ::Location.create!(country: location.country, city: location.city)
        end
      end
      Rails.logger.info('-- end update location')
    end
  end
end
