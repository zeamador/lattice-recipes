class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|

      t.string :description
      t.float :quantity
      t.string :unit

      t.references :recipe, index: true

      t.timestamps
    end
  end
end
