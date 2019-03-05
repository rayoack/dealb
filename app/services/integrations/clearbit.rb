module Integrations
  class Clearbit
    def initialize(resource)
      @resource = resource
    end

    def enrich
      return enrich_company if resource.is_a?(Company)
    rescue ActiveRecord::RecordInvalid
      nil
    end

    private

    attr_reader :resource

    def enrich_company
      return unless resource.is_a?(Company)

      data = company_data(name: resource.name)
      resource.update_from_clearbit(data)
      resource
    end

    def company_data(name:)
      data = ::Clearbit::Enrichment::Company.find(domain(name))
                                            .deep_symbolize_keys
      Company.attributes_from_clearbit(data)
    end

    def domain(name)
      ::Clearbit::NameDomain.find(name: name)&.slice(:domain) || {}
    end
  end
end
