# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportMarket
    def run
      ImportOldDatabaseService::Entities::Market.find_each do |market|
        printf('.')

        ::Market.create!(name: market.name)
      end

      puts "\nImported market - final statistics"
      puts "count: #{::Market.count} markets"
    end
  end
end
