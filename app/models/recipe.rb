class Recipe < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  has_many :ingredients, :dependent => :destroy
  belongs_to :user
  belongs_to :meal
  accepts_nested_attributes_for :steps, :reject_if =>
                                lambda { |a| a[:description].blank? }, 
                                :allow_destroy => true
  accepts_nested_attributes_for :ingredients, :reject_if =>
                                lambda { |a| a[:description].blank? }, 
                                :allow_destroy => true

  def self.search(query)
    where("title like ? OR tags like ?", "%#{query}%", "%#{query}%")
  end

end
