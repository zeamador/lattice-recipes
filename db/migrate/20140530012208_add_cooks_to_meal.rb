class AddCooksToMeal < ActiveRecord::Migration
  def change
  	add_column :meals, :cooks, :integer, default: 1
  end
end
