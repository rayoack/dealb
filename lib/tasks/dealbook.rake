namespace :dealbook do
  desc "TODO"
  task remove_dups: :environment do
    sql = <<-SQL
    SELECT	
      c."name", COUNT(c.id) as qtd, MIN(id) as min_id,
      string_agg(DISTINCT id, ',')
    FROM	
      companies as c 
    GROUP BY c."name" HAVING COUNT(c.id)  > 1
    ORDER BY qtd DESC
    SQL

    dupes = ActiveRecord::Base.connection.exec_query(sql, :SQL, [], prepare: true ).to_a

    print dupes
  end

end
