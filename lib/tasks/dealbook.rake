require 'open-uri'
require 'csv'

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


  task importcompany: :environment do

    s3 = Aws::S3::Client.new( 
      access_key_id: 'AKIA37SVVXBHYQC3NTVA', 
      region: 'us-east-1',
      secret_access_key: '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' )

    ImportCsv.where( status: :pending, import_type: :company ).all.each do |csv|
      key = csv.filename.sub 'https://cloud-cube.s3.amazonaws.com/', ''
      
      begin
        file = s3.get_object( bucket: 'cloud-cube', key: key ).body.read
      rescue
        puts "No key found ", key
        next
      end

      CSV.parse( file, headers: true ) do |line|
        company_hash = line.to_h


        next if Company.where( name: company_hash["name"]).present?

        company = Company.new( company_hash )
        company.save
      end

      csv.status = 'completed'
      csv.save
    end
  end

end
