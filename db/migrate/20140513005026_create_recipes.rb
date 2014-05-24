class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.boolean :temp, default: false
      t.string :title
      t.integer :serving, default: 1
      t.boolean :secret, default: false
      t.string :tags
      t.text :ingredients

      t.references :user, index: true
      t.references :meal, index: true

      t.timestamps
    end
  end
end
