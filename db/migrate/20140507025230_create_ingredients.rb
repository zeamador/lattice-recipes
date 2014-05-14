class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|

      t.float :quantity
      t.string :unit
      t.string :description

      t.references :recipe, index: true

      t.timestamps
    end
  end
end
