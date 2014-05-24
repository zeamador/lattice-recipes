class Recipe < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :steps, 
                                :allow_destroy => true

  validates :title, presence: true
  validates :tags, presence: true
  validates :ingredients, presence: true
  validates :steps, presence: true
  validates :serving, numericality: { greater_than_or_equal_to: 1 }

  # sanitize case
  before_save do
    self.title = self.title.downcase.titleize 
    self.tags.downcase!
  end

  before_create :deduce_final_steps

  def self.search(query)
    lowered = query.downcase
    where("lower(title) like ? OR tags like ?", "%#{lowered}%", "%#{lowered}%")
  end

  private
  def deduce_final_steps
    not_final = Set[]

    # Assemble a list of step numbers of steps that are not final
    self.steps.each do |step|
      step.step_mappers.each do |step_mapper|        
        not_final << step_mapper.prereq_step_number
      end
    end

    # Set each step to be not final if it appears in the not final list, and
    # final otherwise.
    self.steps.each do |step|
      step.final_step = !not_final.include?(step.step_number)
    end
  end
end
