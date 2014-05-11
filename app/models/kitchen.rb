class Kitchen < ActiveRecord::Base
  belongs_to :user

  validates(:equipment, presence: true)
end
