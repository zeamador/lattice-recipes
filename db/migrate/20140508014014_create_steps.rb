class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|

      t.text :description
      t.integer :time
      t.string :attentiveness
      t.integer :step_number
      t.boolean :final_step
      t.string :equipment

      t.references :recipe, index: true

      t.timestamps
    end
  end
end
