class Resources
  FOCUS_PER_USER = 3

  def initialize(kitchen, num_users)
    @free_equipment = kitchen.clone
    @free_focus = num_users * FOCUS_PER_USER
    # The preheat step that currently owns the oven
    @preheat_step = nil
  end

  def initialize_copy(other)
    super
    @free_equipment = @free_equipment.clone
  end

  # Public: Consume the resources required by a step, if possible. If
  #         unsuccessful, this Resources object is left in an UNDEFINED STATE.
  #
  # Returns true if resources were consumed, false otherwise.
  def consume(step)
    # If this step's equipment is an oven, a preheat step owns the oven, the
    # step is not the preheat step that owns the oven, and the step's preheat
    # prereq is not the step that owns the oven, fail.
    if(step.equipment == :OVEN && !@preheat_step.nil? &&
       step != @preheat_step && @preheat_step != step.preheat_prereq)
      return false
    end

    unless step.equipment.nil?
      if @free_equipment[step.equipment] != 0
        @free_equipment[step.equipment] -= 1
      else
        return false
      end
    end

    unless step.preheat_prereq.nil?
      @preheat_step = step.preheat_prereq
    end

    focus_val = FocusTypes.const_get(step.focus)
    if @free_focus >= focus_val
      @free_focus -= focus_val
      true
    else
      false
    end
  end

  # Public: Release the resources consumed by a step. Release may only be called
  #         with a step after consume has been called successfully (returned
  #         true) on the same step. There is a 1-to-1 relationship between
  #         calls to consume and calls to release.
  #
  # Returns nothing.
  def release(step)
    if step == @preheat_step
      @preheat_step = nil
    end

    unless step.equipment.nil?
      @free_equipment[step.equipment] += 1
    end

    @free_focus += FocusTypes.const_get(step.focus)
  end
end
