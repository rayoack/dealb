class AddDolarReferenceToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :amount_dolar, :bigint
    add_column :deals, :pre_valuation_dolar, :bigint
  end
end
