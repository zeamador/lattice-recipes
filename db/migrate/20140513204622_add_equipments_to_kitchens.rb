class AddEquipmentsToKitchens < ActiveRecord::Migration
  def change
	add_column :kitchens, :burner, :integer, default: 4
	add_column :kitchens, :over, :integer, default: 1
	add_column :kitchens, :microwave, :integer, default: 1
	add_column :kitchens, :sink, :integer, default: 2
	add_column :kitchens, :toaster, :integer, default: 1
  end
end
