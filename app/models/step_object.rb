require "set"

# Immutable recipe step.
class StepObject

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
  #
  # Raise error if time is not positive, if attentiveness is not 0, 1, or 2,
  # or if immediate/preheat prereqs are not in set of prereqs.
  def initialize(description, time, attentiveness, recipe_id,
                 equipment: Set[], prereqs: Set[], immediate_prereq: nil, 
                 preheat_prereq: nil)
    @description = description

    # time must be positive
    if(time > 0)
      @time = time
    else
      raise "Time was not given in positive minutes"
    end
      
    # attentiveness must 0, 1, or 2
    if(attentiveness == 0 || attentiveness == 1 || attentiveness == 2)
      @attentiveness = attentiveness
    else
      raise "Time was not given in positive minutes"
    end

    @recipe_id = recipe_id
    @equipment = equipment
    @prereqs = prereqs

    # validate and set prerequisites
    @immediate_prereq = validate_prereq(prereqs, immediate_prereq)
    @preheat_prereq = validate_prereq(prereqs, preheat_prereq)
  end

  private
  # Private - If the given prereq exists, ensure that it is in the set of
  # prereqs and return it.
  #
  # prereqs - Set of step prereqs, should not be nil.
  # prereq - Preheat/immediate prereq Step to be validated.
  def validate_prereq(prereqs, prereq)
    if(prereq && (!prereqs || !prereqs.include?(prereq)))
      raise "Not all special prereqs were in the given set of prereqs"
    end
    prereq
  end
end

