class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name

      t.timestamps
    end

    Currency.create :name => "CAD"
    Currency.create :name => "HKD"
    Currency.create :name => "USD"
    Currency.create :name => "PHP"
    Currency.create :name => "DKK"
    Currency.create :name => "HUF"
    Currency.create :name => "CZK"
    Currency.create :name => "GBP"
    Currency.create :name => "RON"
    Currency.create :name => "SEK"
    Currency.create :name => "IDR"
    Currency.create :name => "INR"
    Currency.create :name => "BRL"
    Currency.create :name => "RUB"
    Currency.create :name => "HRK"
    Currency.create :name => "JPY"
    Currency.create :name => "THB"
    Currency.create :name => "CHF"
    Currency.create :name => "EUR"
    Currency.create :name => "MYR"
    Currency.create :name => "BGN"
    Currency.create :name => "TRY"
    Currency.create :name => "CNY"
    Currency.create :name => "NOK"
    Currency.create :name => "NZD"
    Currency.create :name => "ZAR"
    Currency.create :name => "MXN"
    Currency.create :name => "SGD"
    Currency.create :name => "AUD"
    Currency.create :name => "ILS"
    Currency.create :name => "KRW"
    Currency.create :name => "PLN"

  end
end
