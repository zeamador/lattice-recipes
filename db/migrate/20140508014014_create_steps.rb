class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|

      t.text :description
      t.integer :time
      t.integer :attentiveness
      t.integer :step_number
      t.boolean :final_step

      t.references :recipe, index: true
      t.references :equipment, index: true

      t.timestamps
    end
  end
end
