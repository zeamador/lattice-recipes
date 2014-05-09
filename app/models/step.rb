require "set"

# Immutable recipe step.
class Step < ActiveRecord::Base
  belongs_to :recipe

  attr_reader :description, :time, :attentiveness, :recipe_id,
              :equipment, :prereqs, :immediate_prereq, :preheat_prereq

  # Public: Initialize Step with required and optional features.
  #
  # description - Human readable String description of the step.
  # time - Positive Integer number of minutes the step requires.
  # attentiveness - Integer value where 0 = NONE, 1 = SOME, 2 = ALL.
  # recipe_id - Integer uniquely identifying the recipe this step belongs to.
  #
  # equipment - Set of EquipmentTypes constants. 
  #             Default is an empty Set.
  # prereqs - Set of Step objects representing unchained prerequisite steps. 
  #           Default is an empty Set.
  # immediate_prereq - Step object representing this step's immediate prereq.
  #                    Default is nil.
  # preheat_prereq - Step object representing the prereq step that preheated the
  #                  oven for this step to use.
  #                  Default is nil.
  def initialize(description, time, attentiveness, recipe_id,
                 equipment: Set[], prereqs: Set[], immediate_prereq: nil, 
                 preheat_prereq: nil)
    @description = description
    @time = time
    @attentiveness = attentiveness
    @recipe_id = recipe_id
    @equipment = equipment
    @prereqs = prereqs
    @immediate_prereq = immediate_prereq
    @preheat_prereq = preheat_prereq
  end
end

