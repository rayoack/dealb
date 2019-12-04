class AddExchangeRatesToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :exchange_rates, :decimal, :precision => 15, :scale => 10
  end
end
