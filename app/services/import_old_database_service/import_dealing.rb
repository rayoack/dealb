# frozen_string_literal: true

class ImportOldDatabaseService
  class ImportDealing
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity
    def run
      ImportOldDatabaseService::Entities::Dealing.find_each do |dealing|
        printf('.')
        @dealing = dealing

        next if dealing.deal_id.nil?

        @old_deal = Entities::Deal.find(dealing.deal_id)

        raise unless dealing.buyer_type == 'Investor' ||
                     dealing.buyer_type == 'Company'

        if dealing.buyer_type == 'Investor'
          # rubocop:disable Style/RescueModifier
          @buyer = Entities::Investor.find(dealing.buyer_id) rescue nil
          # rubocop:enable Style/RescueModifier

          next if @buyer.nil?
        else
          @buyer = Entities::Company.find(dealing.buyer_id)
        end

        @person = ::Person.find_by(permalink: @buyer.slug)
        @company = ::Company.find_by(permalink: @buyer.slug)

        @investor = (@person || @company).investor
        @investor ||= Investor.create!(investable: (@person || @company))

        # Achar o deal no lado do novo pelas informacoes do deal antigo
        @new_deal = ::Deal.find_by!(
          close_date: @old_deal.close_date,
          company_id: company(@old_deal).id
        )

        @deal_investor = DealInvestor.new(deal: @new_deal, investor: @investor)

        @deal_investor.save!
      end

      Rails.logger.info("-- imported #{::DealInvestor.count} deal_investors")
    rescue StandardError
      raise
    end

    def update
      Rails.logger.info('-- update dealing')
      ImportOldDatabaseService::Entities::Dealing
        .where("deal_id is not null and (buyer_type = 'Investor' or buyer_type = 'Company')")
        .find_each do |dealing|
          @dealing = dealing
          @old_deal = Entities::Deal.find(dealing.deal_id)

          if dealing.buyer_type == 'Investor'
            # rubocop:disable Style/RescueModifier
            @buyer = Entities::Investor.find(dealing.buyer_id) rescue nil
            # rubocop:enable Style/RescueModifier
            next if @buyer.nil?
          else
            @buyer = Entities::Company.find(dealing.buyer_id)
          end

          @person = ::Person.find_by(permalink: @buyer.slug)
          @company = ::Company.find_by(permalink: @buyer.slug)

          @investor = (@person || @company).investor
          @investor ||= Investor.create!(investable: (@person || @company))

          # Achar o deal no lado do novo pelas informacoes do deal antigo
          @new_deal = ::Deal.find_by!(
            close_date: @old_deal.close_date,
            company_id: company(@old_deal).id
          )

          @deal_investor = DealInvestor.find_by(deal: @new_deal, investor: @investor)
          @deal_investor ||= DealInvestor.create!(deal: @new_deal, investor: @investor)
      end
      Rails.logger.info('-- end update dealing')
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength

    private

    def company(deal)
      company_name = ImportOldDatabaseService::Entities::Company
        .find(deal.company_id)
        .name

      ::Company.find_by!(name: company_name)
    end
  end
end
