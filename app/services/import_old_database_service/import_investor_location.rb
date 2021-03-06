# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportInvestorLocation
    def run
      @localizable_count_before = ::Localizable.count
      ImportOldDatabaseService::Entities::InvestorLocation.all.each do |investor_location|
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
        @location = ::Location.find_by!(
          city: @old_location.city, country: @old_location.country, region: @old_location.region
        )

        if @company.present? 
          if !::CompanyLocation.exists?(location: @location, company: @company)
            ::CompanyLocation.create!(location: @location, company: @company)
          end
        end
        if @person.present?
          if !::PersonLocation.exists?(location: @location, person: @person)
            ::PersonLocation.create!(location: @location, person: @person)
          end
        end
        # @investable = (@person || @company)
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
  end
end
