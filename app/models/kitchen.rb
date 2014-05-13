class Kitchen < ActiveRecord::Base
  has_one :user

  #validates(:equipment, presence: true)
end
