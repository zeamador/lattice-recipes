class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.boolean :secret
      t.string :tags

      t.references :user, index: true

      t.timestamp
    end
  end
end
