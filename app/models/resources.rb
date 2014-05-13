class Resources
  FOCUS_PER_USER = 2

  def initialize(kitchen, num_users)
    @free_equipment = kitchen.clone
    @free_focus = num_users * FOCUS_PER_USER
  end

  # Public: Consume the resources required by a step, if possible. If
  #         unsuccessful, this Resources object is left in an UNDEFINED STATE.
  #
  # Returns true if resources were consumed, false otherwise.
  def consume(step)
    step.equipment.each do |equipment|
      if @free_equipment.has_key?(equipment) && @free_equipment[equipment] != 0
        @free_equipment[equipment] -= 1
      else
        return false
      end
    end

    if @free_focus >= step.focus
      @free_focus -= step.focus
    else
      false
    end

    true
  end

  # Public: Release the resources consumed by a step. Release may only be called
  #         with a step after consume has been called successfully (returned
  #         true) on the same step. There is a 1-to-1 relationship between
  #         calls to consume and calls to release.
  #
  # Returns nothing.
  def release(step)
    step.equipment.each do |equipment|
      @free_equipment[equipment] += 1
    end
    
    @free_focus += step.focus
  end  
end
