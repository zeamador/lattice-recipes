class Recipe < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  has_many :ingredients, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :steps, 
                                :allow_destroy => true
  accepts_nested_attributes_for :ingredients,
                                :allow_destroy => true

  validates :title, presence: true
  validates :tags, presence: true
  validates :steps, presence: true
  validates :ingredients, presence: true

  # sanitize case
  before_save do
    self.tags.downcase!
    self.title = self.title.downcase.titleize
  end

  def self.search(query)
    where("title like ? OR tags like ?", "%#{query}%", "%#{query}%")
  end
end
