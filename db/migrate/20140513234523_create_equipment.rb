class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|

      t.integer :burner, default: 0
      t.integer :oven, default: 0
      t.integer :microwave, default: 0
      t.integer :sink, default: 0
      t.integer :toaster, default: 0
      
      t.timestamps
    end
  end
end
