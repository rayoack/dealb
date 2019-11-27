# frozen_string_literal: true

class ImportOldDatabaseService
  CONNECTION_CONFIG = {
    adapter: 'postgresql',
    encoding: 'utf8',
    host: ENV.fetch('DEALBOOK_IMPORT_DB_HOST'),
    database: ENV.fetch('DEALBOOK_IMPORT_DB_DATABASE'),
    pool: 5,
    username: ENV.fetch('DEALBOOK_IMPORT_DB_USERNAME'),
    password: ENV.fetch('DEALBOOK_IMPORT_DB_PASSWORD')
  }.freeze

  def self.run
    new.send(:run)
  end

  private

  def run
    handle_errors do
      ImportOldDatabaseService::ImportMarket.new.run
      ImportOldDatabaseService::ImportCompany.new.run
      ImportOldDatabaseService::ImportDeal.new.run
      ImportOldDatabaseService::ImportCompanyMarket.new.run
      ImportOldDatabaseService::ImportLocation.new.run
      ImportOldDatabaseService::ImportCompanyLocation.new.run
      ImportOldDatabaseService::ImportInvestor.new.run
      ImportOldDatabaseService::ImportInvestorLocation.new.run
      ImportOldDatabaseService::ImportInvestorMarket.new.run
      ImportOldDatabaseService::ImportDealing.new.run
      ImportOldDatabaseService::ImportUser.new.run
    end
  end

  def safe_run
    handle_errors do
      puts 'market\n'
      iMarket = ImportOldDatabaseService::ImportMarket.new.run
      iMarket.present? 
        puts 'location\n'
        iLocation = ImportOldDatabaseService::ImportLocation.new.run
        iLocation.present?
          puts 'user\n'
          iUser = ImportOldDatabaseService::ImportUser.new.run
          iUser.present?
            puts 'company\n'
            iCompany = ImportOldDatabaseService::ImportCompany.new.run
            iCompany.present?
              puts 'companyMarket\n'
              iCompanyMarket = ImportOldDatabaseService::ImportCompanyMarket.new.run
              iCompanyMarket.present?
                puts 'companyLocation\n'
                iCompanyLocation = ImportOldDatabaseService::ImportCompanyLocation.new.run
                iCompanyLocation.present?
                  puts 'investor\n'
                  iInvestor = ImportOldDatabaseService::ImportInvestor.new.run
                  iInvestor.present?
                    puts 'investorLocation\n'
                    iInvestorLocation = ImportOldDatabaseService::ImportInvestorLocation.new.run
                    iInvestorLocation.present?
                      puts 'investorMarket\n'
                      iInvestorMarket = ImportOldDatabaseService::ImportInvestorMarket.new.run
                      iInvestorMarket.present?   
                        puts 'deal\n'
                        ideal = ImportOldDatabaseService::ImportDeal.new.run
                        ideal.present?
                          puts 'dealing\n'
                          iDealing = ImportOldDatabaseService::ImportDealing.new.run   
    end
  end

  def handle_errors
    ActiveRecord::Base.transaction do
      yield
    rescue StandardError => e
      Rails.logger.debug(e.message)

      raise
    end
  end
end
