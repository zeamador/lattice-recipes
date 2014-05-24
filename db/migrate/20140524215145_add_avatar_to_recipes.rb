class AddAvatarToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :avatar, :string
  end
end
