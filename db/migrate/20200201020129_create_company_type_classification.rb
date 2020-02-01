class CreateCompanyTypeClassification < ActiveRecord::Migration[5.1]
  def change
    create_table :company_type_classifications do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    CompanyTypeClassification.create :name => "Education"
    CompanyTypeClassification.create :name => "Government"
    CompanyTypeClassification.create :name => "Nonprofit"
    CompanyTypeClassification.create :name => "Private"
    CompanyTypeClassification.create :name => "Public"
    CompanyTypeClassification.create :name => "Personal"
  end
end
