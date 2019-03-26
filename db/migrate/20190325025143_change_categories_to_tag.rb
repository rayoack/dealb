class ChangeCategoriesToTag < ActiveRecord::Migration[5.1]
  def change
    rename_column :investors, :category, :tag
  end
end
