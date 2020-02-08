class CreateCompanyNaicsCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :company_naics_codes, {:id => false} do |t|
      t.integer :code, :null => false, index: true
      t.string :description

      t.timestamps
    end

    CompanyNaicsCode.create :code => 11, :description => "Agriculture, forestry, fishing and hunting"
    CompanyNaicsCode.create :code => 21, :description => "Mining"
    CompanyNaicsCode.create :code => 22, :description => "Utilities"
    CompanyNaicsCode.create :code => 23, :description => "Construction"
    CompanyNaicsCode.create :code => 31, :description => "Manufacturing"
    CompanyNaicsCode.create :code => 32, :description => "Manufacturing"
    CompanyNaicsCode.create :code => 33, :description => "Manufacturing"
    CompanyNaicsCode.create :code => 42, :description => "Wholesale trade"
    CompanyNaicsCode.create :code => 44, :description => "Retail trade"
    CompanyNaicsCode.create :code => 45, :description => "Retail trade"
    CompanyNaicsCode.create :code => 48, :description => "Transportation and warehousing"
    CompanyNaicsCode.create :code => 49, :description => "Transportation and warehousing"
    CompanyNaicsCode.create :code => 51, :description => "Information"
    CompanyNaicsCode.create :code => 52, :description => "Finance and insurance"
    CompanyNaicsCode.create :code => 53, :description => "Real estate and rental and leasing"
    CompanyNaicsCode.create :code => 54, :description => "Professional, scientific, and technical services"
    CompanyNaicsCode.create :code => 55, :description => "Management of companies and enterprises"
    CompanyNaicsCode.create :code => 56, :description => "Administrative and support and waste management and remediation services"
    CompanyNaicsCode.create :code => 61, :description => "Education services"
    CompanyNaicsCode.create :code => 62, :description => "Health care and social assistance"
    CompanyNaicsCode.create :code => 71, :description => "Arts, entertainment, and recreation"
    CompanyNaicsCode.create :code => 72, :description => "Accommodation and food services"
    CompanyNaicsCode.create :code => 81, :description => "Other services, except public administration"
    CompanyNaicsCode.create :code => 92, :description => "Public administration"
    CompanyNaicsCode.create :code => 99, :description => "Unclassified"
  end
end
