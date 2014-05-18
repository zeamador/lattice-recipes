class Kitchen < ActiveRecord::Base
  has_one :user

  validates :burner, numericality: { greater_than_or_equal_to: 0 }
  validates :oven, numericality: { greater_than_or_equal_to: 0 }
  validates :microwave, numericality: { greater_than_or_equal_to: 0 }
  validates :sink, numericality: { greater_than_or_equal_to: 0 }
  validates :toaster, numericality: { greater_than_or_equal_to: 0 }
end
