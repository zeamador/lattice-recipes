class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|

      t.timestamps
    end
  end
end
