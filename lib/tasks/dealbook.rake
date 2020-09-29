namespace :dealbook do
  desc "Dealbook tasks"

  task send_news: :environment do
    helper = SendgridMailerService.new
    helper.sendNews()
  end

  task remove_dups: :environment do
    sql = <<-SQL
    SELECT	
    c."name", COUNT(c.id) as qtd, MIN(id) as min_id,
    string_agg(DISTINCT id::varchar, ',') as others
    FROM	
      companies as c 
    GROUP BY c."name" HAVING COUNT(c.id)  > 1
    ORDER BY qtd DESC
    SQL

    dupes = ActiveRecord::Base.connection.exec_query(sql, :SQL, [], prepare: true ).to_a

    print dupes
    dupes.each do |dup|
      name = dup["name"]
      principal_id = dup["min_id"]
      others = dup["others"].split(",")
      others.delete(principal_id)

      ActiveRecord::Base.connection.exec_query(
        "UPDATE deals SET company_id = $1 WHERE company_id IN(#{others.join(",")})", :SQL, [[nil,principal_id]], prepare: true )
      ActiveRecord::Base.connection.exec_query(
        "UPDATE investors SET investable_id = $1 WHERE investable_id IN(#{others.join(",")}) and investable_type = 'Company'", :SQL, [[nil,principal_id]], prepare: true )
      ActiveRecord::Base.connection.exec_query(
          "INSERT INTO companies_deleted SELECT * FROM companies WHERE id IN(#{others.join(",")})", :SQL, [], prepare: true )
      ActiveRecord::Base.connection.exec_query(
          "DELETE FROM companies WHERE id IN(#{others.join(",")})", :SQL, [], prepare: true )
          
    end
    print dupes
  end

end
