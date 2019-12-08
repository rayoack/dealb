# frozen_string_literal: true

class MyCompany < ActiveRecord::Base
  self.table_name = 'companies'
  has_one :investor, as: :investable, dependent: :destroy
end
class MyPerson < ActiveRecord::Base
  self.table_name = 'people'
  has_one :investor, as: :investable, dependent: :destroy
end

class ImportOldDatabaseService
  class ImportInvestor
    # update line 30 foard, mapped by Andre
    PERSONS = %w[
      diether-werninghaus flavio-jansen
      gilmar-francisco-pertile kai-schoppen hans-hickler
      in-hsieh joao-alceu-amoroso-lima
      jose-marin joe-lonsdale adriana-cisneros peter-fernandez
      fabrice-grinda christian-gessner stefan-schimenes
      patrick-lisbona peter-thiel fernanda-feitosa
      luis-carlos-freitas tony-perkins ted-maidenberg
      marcelo-loureiro niraj-shah christian-friedland
      martin-varsavsky romero-rodrigues luis-mario-bilenky
      christian-ribeiro anibal-messa kees-koolen nicolas-gautier
      lee-jacobs gui-afonso bruno-sales-rabelo jonathan-coon
      mike-levinthal rafael-bertani galen-hardy
      cassio-spina gabriel-jaramillo rodrigo-borges
      antonio-henrique-prado eduardo-steiner pedro-navio bryan-johnson
      craig-earnshaw antonio-carlos-soares silvio-genesini
      antonio-de-athayde nicolas-berggruen joao-kepler-braga carlos-gamboa
      felipe-melo mario-letelier mauricio-de-chiaro john-berkowitz
      carlos-andre-montenegro mayer-mizrachi luis-loaiza alberto-vera
      mark-goines peter-kellner guilherme-horn thiago-sarraf
      fabio-povoa rodrigo-dantas daniel-amato ron-burkle vinod-khosla steve-case
      guilherme-cruz warburg-pincus marcelo-maisonnave rodrigo-quinalha
      thamila-zaher pedro-sirotsky george-soros enrique-collado
      rafael-assuncao marco-poli eduardo-smith paulo-ferraz
      carlos-nissel daniel-tinoco klaus-hommels oliver-jung daniel-gutenberg
      florian-otto vinicius-marchini angelica luciano-huck greg-waldorf simon-baker
      shaun-di-gregorio wences-casares micky-malka ariel-poler gordon-rubenstein
      jeff-fluhr errol-damelin alxandre-alves ricardo-loureiro philipp-povel
      roger-ingold sandro-reiss jaime-de-paula cesar-bertini wilson-amaral
      diego-stark julio-sergio-cardozo leonardo-pereira paulo-camargo rodrigo-calvo-galindo
      oscar-salazar jander-martins michelli-maldonado christian-pensa gabriel-gomes
      joao-daniel-almeida carlos-barreiros daniel-orlean andre-barros mike-krieger
      andre-gomes marc-lemann arminio-fraga david-feffer luiz-fernando-figueiredo
      wolff-klabin daniel-goldberg julio-vasconcellos bruno-nardon max-levchin
      eric-wu david-velez hugo-barra sergio-furio
    ].freeze

    # rubocop:disable Metrics/MethodLength
    def run
      # rubocop:disable Metrics/BlockLength
      ImportOldDatabaseService::Entities::Investor.find_each do |investor|
        printf('.')

        @investor = investor

        if PERSONS.include?(investor.slug)
          @person = ::Person.create!(
            first_name: investor.name,
            # last_name: '',
            permalink: investor.slug.strip.presence,
            description: investor.description.presence,
            # born_date: '',
            # gender: '',
            # phone_number: '',
            # occupation: '',
            # email: '',
            website_url: investor.website.strip.presence,
            # facebook_url: '',
            # twitter_url: '',
            # google_plus_url: '',
            linkedin_url: investor.linkedin.strip.presence
          )

          @new_investor1 = ::Investor.create!(
            investable: @person,
            status: investor.status || Investor::ACTIVE,
            tag: ::Investor::ANGEL
            # stage: investor.stage.strip.presence
          )
        else
          @company = Company.find_by(permalink: investor.slug.strip.presence)

          @company ||= ::Company.create!(
            name: investor.name.presence,
            permalink: investor.slug.strip.presence,
            description: investor.description.presence,
            # employees_count: '',
            # born_date: '',
            # phone_number: '',
            # email: '',
            homepage_url: investor.website.try(:strip).presence,
            linkedin_url: investor.linkedin.try(:strip).presence,
            # facebook_url: '',
            # twitter_url: '',
            # google_plus_url: '',
            status: investor.status || Investor::ACTIVE
          )

          @new_investor2 = ::Investor.create!(
            investable: @company,
            status: investor.status || Investor::ACTIVE,
            tag: ::Investor::ANGEL
            # stage: investor.stage.strip.presence
          )
        end

      rescue StandardError
        raise
      end

      Rails.logger.info("-- imported #{::Investor.count} investors")
      # rubocop:enable Metrics/BlockLength
    end

    def update
      Rails.logger.info('-- update investor')
      ImportOldDatabaseService::Entities::Investor.find_each do |investor|
        if PERSONS.include?(investor.slug)
          updatePeople(investor)
        else
          updateCompany(investor)
        end
      end
      Rails.logger.info('-- end update investor')
    end

    def updateCompany(investor)
      @company = ::Company.find_by(permalink: investor.slug.strip.presence)
      @company ||= ::MyCompany.create!(
        name: investor.name.presence,
        permalink: investor.slug.strip.parameterize.presence,
        description: investor.description.presence,
        homepage_url: investor.website.try(:strip).presence,
        linkedin_url: investor.linkedin.try(:strip).presence,
        status: investor.status || Investor::ACTIVE
      )
      @investor = @company.investor
      @investor ||= ::Investor.create!(
        investable: @company,
        status: investor.status || ::Investor::ACTIVE,
        tag: ::Investor::ANGEL
      )
    end

    def updatePeople(investor)
      @person = ::Person.find_by(permalink: investor.slug.strip.presence)
      @person ||= ::MyPerson.create!(
        first_name: investor.name,
        permalink: investor.slug.strip.parameterize.presence,
        website_url: investor.website.try(:strip).presence,
        linkedin_url: investor.linkedin.try(:strip).presence,
      )
      @investor = @person.investor
      @investor ||= ::Investor.create!(
        investable: @person,
        status: investor.status || ::Investor::ACTIVE,
        tag: ::Investor::ANGEL
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
