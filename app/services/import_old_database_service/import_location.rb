# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportLocation
    def run
      puts '-- location'
      ImportOldDatabaseService::Entities::Location.find_each do |location|
        printf('.')
        ::Location.create!(country: location.country, city: location.city)
      end
      puts "-- imported #{::Location.count} locations"
    end
  end
end
