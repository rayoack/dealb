class GlobalSearcher
  def initialize(search)
    @search = search
  end

  def call
    call!
  rescue ActiveRecord::RecordNotFound
    []
  end

  def call!
    companies = Company.where('name ILIKE ?', "%#{search}%")
    people_by_first_name = Person.where('first_name ILIKE ?', "%#{search}%")
    people_by_last_name = Person.where('last_name ILIKE ?', "%#{search}%")
    investor_by_company = Investor.company(companies.select(:id))
    investor_by_person = Investor.people(people_by_first_name.pluck(:id) +
                                         people_by_last_name.pluck(:id))
    investor_by_tag = Investor.where('tag ILIKE ?', "%#{search}%")
    deals_by_company = Deal.where(company_id: companies.select(:id))

    Array(people_by_first_name.to_a +
          people_by_last_name.to_a +
          companies.to_a +
          investor_by_company.to_a +
          investor_by_person.to_a +
          investor_by_tag.to_a +
          deals_by_company.to_a).uniq
  end

  private

  attr_reader :search
end
