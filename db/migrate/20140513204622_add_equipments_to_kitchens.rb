class AddEquipmentsToKitchens < ActiveRecord::Migration
  def change
    default_kitchen = KitchenObject.new

    EquipmentTypes.constants.each do |constant|
      add_column :kitchens, constant.downcase, :integer, 
                 default: default_kitchen[constant]
    end
  end
end
