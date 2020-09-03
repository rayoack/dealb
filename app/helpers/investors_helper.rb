# frozen_string_literal: true

module InvestorsHelper
  def all_investable_entities( ctx )
    sql = <<-SQL
      SELECT 
        MAX(a.id) as id, MAX(investor_id) as investor_id,
        MAX(type) as type,
        name
      FROM
        (
        SELECT
        p.id, i.id as investor_id, 'Person' as type, CONCAT(p.first_name, ' ', p.last_name) as name
      FROM
        people as p
        LEFT JOIN investors as i ON i.investable_type = 'Person' and i.investable_id = p.id
        WHERE p.domain_country_context = $1
      UNION 
      SELECT
        o.id,i.id as investor_id, 'Company' as type, o.name
      FROM
        companies as o 
        LEFT JOIN investors as i ON i.investable_type = 'Company' and i.investable_id = o.id
      WHERE o.domain_country_context = $1
        ) as a 
      GROUP BY name 
      ORDER BY name ASC
    SQL

    ActiveRecord::Base.connection.exec_query(sql, :SQL, [[nil, ctx]], prepare: true ).to_a
  end

  def possible_new_investors
    people = Person.all.collect do |p|
      ["#{p.name}- Person", p.permalink]
    end

    companies = Company.all.collect do |p|
      ["#{p.name}- Company", p.permalink]
    end

    Array(people + companies)
  end
end
