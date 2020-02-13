module Integrations
  class Clearbit
    def initialize(resource)
      @resource = resource
    end

    def enrich
      return enrich_company if resource.is_a?(Company)

      enrich_person if resource.is_a?(Person)
    rescue ActiveRecord::RecordInvalid
      nil
    end

    private

    attr_reader :resource

    def enrich_company
      return unless resource.is_a?(Company)
      return if resource.clearbit_synchronized_at.present?

      data = company_data(name: resource.name)
      resource.update_from_clearbit(data) if data.present?
      resource
    end

    def company_data(name:)
      domain_data = domain(name)

      return if domain_data.blank?

      data = ::Clearbit::Enrichment::Company.find(domain_data)
                                           &.deep_symbolize_keys

      return if data.blank?

      Company.attributes_from_clearbit(data)
    end

    def enrich_person
      return unless resource.is_a?(Person)
      return if resource.clearbit_synchronized_at.present?
      return if !resource.email.present?

      data = person_data(email: resource.email)
      resource.update_from_clearbit(data) if data.present?
      resource
    end

    def person_data(email:)
      data = ::Clearbit::Enrichment::Person.find(email: email, stream: true)
                                          &.deep_symbolize_keys

      return if data.blank?

      Person.attributes_from_clearbit(data)
    end

    def domain(name)
      ::Clearbit::NameDomain.find(name: name)&.slice(:domain) || {}
    end
  end
end
