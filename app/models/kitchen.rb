class Kitchen < ActiveRecord::Base
  has_one :user

  EquipmentTypes.constants.each do |constant|
    validates constant.downcase, numericality: { greater_than_or_equal_to: 0 }
  end
end
