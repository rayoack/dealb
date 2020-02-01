class CreateBusinessTypeClassifications < ActiveRecord::Migration[5.1]
  def change
    create_table :business_type_classifications do |t|
      t.string :name, null: false, index: true
      t.timestamps null: false
    end

    BusinessTypeClassification.create :name => "B2B"
    BusinessTypeClassification.create :name => "B2C"
    BusinessTypeClassification.create :name => "E-commerce"
    BusinessTypeClassification.create :name => "Enterprise"
    BusinessTypeClassification.create :name => "ISP"
    BusinessTypeClassification.create :name => "Marketplace"
    BusinessTypeClassification.create :name => "Mobile"
    BusinessTypeClassification.create :name => "SAAS"
  end
end
