class AddLogoUrlToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :logo_url, :text
  end
end
