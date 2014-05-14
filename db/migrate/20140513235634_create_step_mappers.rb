class CreateStepMappers < ActiveRecord::Migration
  def change
    create_table :step_mappers do |t|

      t.boolean :immediate_prereq
      t.boolean :preheat_prereq
      t.integer :prereq_id
      t.integer :prereq_step_number

      t.references :step, index: true

      t.timestamps
    end
  end
end
