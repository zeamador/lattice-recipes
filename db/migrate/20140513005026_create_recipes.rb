class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :ingredients
      t.string :final_steps
      t.boolean :secret
      t.string :tags

      t.timestamp
    end
  end
end
