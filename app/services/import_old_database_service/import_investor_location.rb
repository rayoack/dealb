# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportInvestorLocation
    # rubocop:disable Metrics/MethodLength
    def run
      @localizable_count_before = ::Localizable.count

      ImportOldDatabaseService::Entities::InvestorLocation
        .all.each do |investor_location|

        printf('.')

        @investor_location = investor_location

        @old_location = Entities::Location.find(investor_location.location_id)
        @old_investor = Entities::Investor.find(investor_location.investor_id)

        @investable = (
          ::Person.find_by(permalink: @old_investor.slug.strip.presence) ||
          ::Company.find_by(permalink: @old_investor.slug.strip.presence)
        )

        @location = ::Location.find_by!(
          city: @old_location.city, country: @old_location.country
        )

        @localizable = ::Localizable.new(
          localizable: @investable,
          location: @location
        )

        @localizable.save!
      end

      Rails.logger.info("-- imported #{::Localizable.count} investor_locations")
    rescue StandardError
      raise
    end

    def update
      Rails.logger.info('-- update investor location')
      ImportOldDatabaseService::Entities::InvestorLocation.all.each do |investor_location|
        @investor_location = investor_location
        @old_location = Entities::Location.find(investor_location.location_id)
        @old_investor = Entities::Investor.find(investor_location.investor_id)
        @person = ::Person.find_by(permalink: @old_investor.slug.strip.parameterize.presence)
        @company = ::Company.find_by(permalink: @old_investor.slug.strip.parameterize.presence)
        @investable = (@person || @company)
        
        @location = ::Location.find_by!(
          city: @old_location.city, country: @old_location.country
        )

        @company.present? 
          if !::CompanyLocation.exists?(location: new_location, company: new_company)
            ::CompanyLocation.create!(location: new_location, company: new_company)
          end
        else
          if !::PersonLocation.exists?(location: new_location, person: new_company)
            ::PersonLocation.create!(location: new_location, person: new_company)
          end
        end
        # @localizable = ::Localizable.find_by(
        #   localizable: @person.present? ? @person : @company,
        #   location: @location,
        # )
        # @localizable ||= ::Localizable.create!(
        #   localizable: @person.present? ? @person : @company,
        #   location: @location,
        #   localizable_type: @person.present? ? 'Person' : 'Company'
        # )
      end
      Rails.logger.info('-- end update investor location')
    end
    # rubocop:enable Metrics/MethodLength
  end
end
