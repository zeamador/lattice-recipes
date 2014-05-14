class Recipe < ActiveRecord::Base
  has_many :steps
  has_many :ingredients
  belongs_to :user

  def self.search(query)
    where("title like ? OR tags like ?", "%#{query}%", "%#{query}%")
  end

end
