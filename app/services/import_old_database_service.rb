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

  def run_old
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

  # rubocop:disable Metrics/MethodLength
  def run
    handle_errors do
      i_merket = ImportOldDatabaseService::ImportMarket.new.run
      i_merket.present?
        i_location = ImportOldDatabaseService::ImportLocation.new.run
        i_location.present?
          i_user = ImportOldDatabaseService::ImportUser.new.run
          i_user.present?
            i_company = ImportOldDatabaseService::ImportCompany.new.run
            i_company.present?
              i_company_market = ImportOldDatabaseService::ImportCompanyMarket.new.run
              i_company_market.present?
                i_company_location = ImportOldDatabaseService::ImportCompanyLocation.new.run
                i_company_location.present?
                  i_deal = ImportOldDatabaseService::ImportDeal.new.run
=begin
                  i_deal.present?
                    i_investor = ImportOldDatabaseService::ImportInvestor.new.run
                    i_investor.present?
                      i_investor_location = ImportOldDatabaseService::ImportInvestorLocation.new.run
                      i_investor_location.present?
                        i_investor_market = ImportOldDatabaseService::ImportInvestorMarket.new.run
                        i_investor_market.present?
                          i_dealing = ImportOldDatabaseService::ImportDealing.new.run
=end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def handle_errors
    ActiveRecord::Base.transaction do
      yield
    rescue StandardError => e
      Rails.logger.debug(e.message)

      raise
    end
  end
  # rubocop:enable Metrics/MethodLength
end
