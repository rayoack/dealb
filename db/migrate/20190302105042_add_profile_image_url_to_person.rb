class AddProfileImageUrlToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :rank, :integer
    add_column :people, :died_on, :datetime

    rename_column :people, :avatar, :profile_image_url
    rename_column :people, :born_date, :born_on
  end
end
