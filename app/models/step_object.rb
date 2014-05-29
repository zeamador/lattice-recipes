require "set"

# Immutable recipe step.
class StepObject

  attr_reader :description, :time, :focus, :recipe_id, :equipment, 
              :prereqs, :immediate_prereq, :preheat_prereq

  # Public: Initialize Step with required and optional features.
  #
  # description - Human readable String description of the step.
  # time - Positive Integer number of minutes the step requires.
  # focus - FocusTypes constant.
  # recipe_id - Integer uniquely identifying the recipe this step belongs to.
  #
  # equipment - EquipmentTypes constant. 
  #             Default is nil.
  # prereqs - Set of Step objects representing unchained prerequisite steps. 
  #           Default is an empty Set.
  # immediate_prereq - Step object representing this step's immediate prereq.
  #                    Default is nil.
  # preheat_prereq - Step object representing the prereq step that preheated the
  #                  oven for this step to use.
  #                  Default is nil.
  #
  # Raise error if time is not positive, if attentiveness is not 0, 1, or 2,
  # if immediate/preheat prereqs are not in set of prereqs, or if equipment
  # is not an EquipmentType or nil.
  def initialize(description, time, focus, recipe_id, equipment: nil, 
                 prereqs: Set[], immediate_prereq: nil, preheat_prereq: nil)
    @description = description

    # time must be positive
    if(time > 0)
      @time = time
    else
      raise "Time was not given in positive minutes"
    end
      
    # focus must be a FocusType
    if(!FocusTypes.constants.include?(focus))
      raise "Focus must be a FocusTypes constant"
    else
      @focus = focus
    end

    @recipe_id = recipe_id

    # equipment must either be nil or an EquipmentType
    if(equipment && !EquipmentTypes.constants.include?(equipment))
      raise "Equipment must either be nil or an EquipmentTypes constant"
    else
      @equipment = equipment
    end

    @prereqs = prereqs

    # validate and set prerequisites
    @immediate_prereq = validate_prereq(prereqs, immediate_prereq)
    @preheat_prereq = validate_prereq(prereqs, preheat_prereq)
  end

  def to_s
    description
  end

  def inspect
    description
  end

  private
  # Internal - If the given prereq exists, ensure that it is in the set of
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

