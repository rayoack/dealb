# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportMarket
    def run
      puts '-- market'
      ImportOldDatabaseService::Entities::Market.find_each do |market|
        printf('.')
        ::Market.create!(name: market.name)
      end
      puts "-- imported #{::Market.count} markets"
    end
  end
end
