class AddPersonToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :person, index: true, foreign_key: true
  end
end
