# frozen_string_literal: true

class CreateInvestors < ActiveRecord::Migration[5.1]
  def change
    create_table :investors do |t|
      t.references :investable, polymorphic: true, null: false, index: true

      t.string :status, default: 'active', null: false, index: true
      t.string :category
      t.string :stage

      # This field allow us to make the switch of platform based on
      # domains like 'uk.dealbook.co' or 'br.dealbook.co'
      t.string :domain_country_context, null: false, default: 'br'

      t.timestamps null: false
    end
  end
end
