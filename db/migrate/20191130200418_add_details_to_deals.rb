class AddDetailsToDeals < ActiveRecord::Migration[5.1]
  def change
    add_column :deals, :amount, :bigint
    add_column :deals, :pre_valuation, :bigint
    
    # update amount with amount_cents and pre_valuation with pre_valuation_cents
    Deal.update_all("amount = amount_cents/100, pre_valuation = pre_valuation_cents/100")
  end
end
