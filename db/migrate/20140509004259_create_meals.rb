class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|

      t.timestamps
    end
  end
end
