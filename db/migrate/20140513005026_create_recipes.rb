class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.boolean :secret
      t.string :tags
      t.string :ingredients

      t.references :user, index: true
      t.references :meal, index: true

      t.timestamps
    end
  end
end
