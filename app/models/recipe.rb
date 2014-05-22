class Recipe < ActiveRecord::Base
  has_many :steps, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :steps, 
                                :allow_destroy => true

  validates :title, presence: true
  validates :tags, presence: true
  validates :ingredients, presence: true
  validates :steps, presence: true

  # sanitize case
  before_save do
    self.title = self.title.downcase.titleize   
    self.tags.downcase!
  end

  # after_create :deduce_final_steps

  def self.search(query)
    where("title like ? OR tags like ?", "%#{query}%", "%#{query}%")
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
   
    #DEBUG
    puts "non-final step numbers:"
    not_final.each do |step_number|
      puts step_number
    end

    puts "final step numbers:"
    # Set all steps that are prereqs to not final
    self.steps.each do |step|
      step.final_step = !not_final.include?(step.step_number)
      puts step.step_number if !not_final.include?(step.step_number)
    end

    raise "a"
  end
end
