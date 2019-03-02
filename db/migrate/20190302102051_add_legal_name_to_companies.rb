class AddLegalNameToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :legal_name, :string
    add_column :companies, :crunchbase_url, :string
    add_column :companies, :stock_symbol, :string
    add_column :companies, :stock_exchange, :string
    add_column :companies, :closed_on, :datetime
    add_column :companies, :rank, :integer

    rename_column :companies, :logo_url, :profile_image_url
    rename_column :companies, :website_url, :homepage_url
    rename_column :companies, :email, :contact_email
    rename_column :companies, :born_date, :founded_on
  end
end
