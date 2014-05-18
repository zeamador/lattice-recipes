class Recipe < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  has_many :ingredients, :dependent => :destroy
  belongs_to :user
  belongs_to :meal
  accepts_nested_attributes_for :steps, 
                                :allow_destroy => true
  accepts_nested_attributes_for :ingredients,
                                :allow_destroy => true

  validates :title, presence: true
  validates :tags, presence: true

  def self.search(query)
    where("title like ? OR tags like ?", "%#{query}%", "%#{query}%")
  end

end
