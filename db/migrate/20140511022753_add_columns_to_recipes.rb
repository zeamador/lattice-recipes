class AddColumnsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :title, :string
    add_column :recipes, :ingredients, :string
    add_column :recipes, :final_steps, :string
    add_column :recipes, :secret, :string
    add_column :recipes, :tags, :string
  end
end
