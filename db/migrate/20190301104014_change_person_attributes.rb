class ChangePersonAttributes < ActiveRecord::Migration[5.1]
  def change
    rename_column :people, :image_url, :avatar
    rename_column :people, :description, :bio
  end
end
