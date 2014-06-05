class Resources
  FOCUS_PER_USER = 3

  def initialize(kitchen, num_users)
    @free_equipment = kitchen.clone
    @free_focus = num_users * FOCUS_PER_USER
    # The preheat step(s) that currently own the oven(s). This is an Array whose
    # length is the number of ovens in the passed kitchen. Nil elements indicate
    # that no step occupies that oven.
    @preheat_steps = []
    kitchen[:OVEN].times do
      @preheat_steps.push(nil)
    end
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
    # Check that the equipment used by this step is free
    unless step.equipment.nil?
      if @free_equipment[step.equipment] != 0
        @free_equipment[step.equipment] -= 1
      else
        return false
      end
    end

    if step.equipment == :OVEN
      if (free_index = @preheat_steps.index(nil)) != nil
        # There is a free preheat step slot, so fill it. If step.preheat_prereq
        # is nil, this will not modify the array
        @preheat_steps[free_index] = step.preheat_prereq
      else
        # There is no free preheat step slot. We cannot consume this step
        # unless it is one of the preheat steps in @preheat_prereqs, or its
        # preheat prereq is one of the preheat steps in @preheat_prereqs
        unless @preheat_steps.include?(step) ||
               @preheat_steps.include?(step.preheat_prereq)
          return false
        end
      end
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
    # If this step is a preheat step, free up the preheat step slot it occupied
    if (index = @preheat_steps.index(step)) != nil
      @preheat_steps[index] = nil
    end

    unless step.equipment.nil?
      @free_equipment[step.equipment] += 1
    end

    @free_focus += FocusTypes.const_get(step.focus)
  end
end
