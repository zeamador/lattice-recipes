class Step < ActiveRecord::Base
  # Invariant: if an immediate prereq exists, it is also in the prereqs list
  belongs_to :recipe

  validates(:description, presence: true)
  validates(:time, presence: true)
  validates(:attentiveness, presence: true)
  validates(:recipe_id, presence: true)
  validates(:equipment, presence: true)
  validates(:prereqs, presence: true)
  validates(:immediate_prereq, presence: true)
  validates(:preheat_prereq, presence: true)
end
