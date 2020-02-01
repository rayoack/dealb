class CreateCompanyEntitySize < ActiveRecord::Migration[5.1]
  def change
    create_table :company_entity_sizes do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    CompanyEntitySize.create :name => "1-10"
    CompanyEntitySize.create :name => "11-50"
    CompanyEntitySize.create :name => "51-250"
    CompanyEntitySize.create :name => "251-1000"
    CompanyEntitySize.create :name => "1001-5000"
    CompanyEntitySize.create :name => "5001-10k"
    CompanyEntitySize.create :name => "10-50k"
    CompanyEntitySize.create :name => "50-100k"
    CompanyEntitySize.create :name => "100k+"
  end
end
