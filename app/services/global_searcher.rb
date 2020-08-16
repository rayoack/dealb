class GlobalSearcher
  def initialize(search)
    @search = ActiveSupport::Inflector.transliterate(search).downcase
  end

  def call
    call!
  rescue ActiveRecord::RecordNotFound
    []
  end

  #
  #lower_unaccent is an postgre function on the server
  #CREATE OR REPLACE FUNCTION lower_unaccent(text)
  #  RETURNS text AS
  #  $func$
  #    SELECT lower(translate($1
  #     , '¹²³áàâãäåāăąÀÁÂÃÄÅĀĂĄÆćčç©ĆČÇĐÐèéêёëēĕėęěÈÊËЁĒĔĖĘĚ€ğĞıìíîïìĩīĭÌÍÎÏЇÌĨĪĬłŁńňñŃŇÑòóôõöōŏőøÒÓÔÕÖŌŎŐØŒř®ŘšşșßŠŞȘùúûüũūŭůÙÚÛÜŨŪŬŮýÿÝŸžżźŽŻŹ'
  #     , '123aaaaaaaaaaaaaaaaaaacccccccddeeeeeeeeeeeeeeeeeeeeggiiiiiiiiiiiiiiiiiillnnnnnnooooooooooooooooooorrrsssssssuuuuuuuuuuuuuuuuyyyyzzzzzz'
  #     ));
  #$func$ LANGUAGE sql IMMUTABLE;
  #
  def call!
    companies = Company.where('lower_unaccent(name) ILIKE ?', "%#{search}%")
    people_by_first_name = Person.where('lower_unaccent(first_name) ILIKE ?', "%#{search}%")
    people_by_last_name = Person.where('lower_unaccent(last_name) ILIKE ?', "%#{search}%")
    #investor_by_company = Investor.company(companies.select(:id))
    #investor_by_person = Investor.people(people_by_first_name.pluck(:id) + people_by_last_name.pluck(:id))
    #investor_by_tag = Investor.where('tag ILIKE ?', "%#{search}%")
    deals_by_company = Deal.where(company_id: companies.select(:id))

    Array(people_by_first_name.to_a +
          people_by_last_name.to_a +
          companies.to_a +
          #investor_by_company.to_a +
          #investor_by_person.to_a +
          #investor_by_tag.to_a +
          deals_by_company.to_a).uniq
  end

  private

  attr_reader :search
end
