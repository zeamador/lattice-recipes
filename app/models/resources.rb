class Resources
  FOCUS_PER_USER = 2

  def initialize(kitchen, num_users)
    @available_equipment = kitchen.clone
    @available_focus = num_users * FOCUS_PER_USER
  end

  def consume(step)
     
  end

  def release(step)
    
  end  
end
