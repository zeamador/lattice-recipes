# A StepFactory ensures that calls to construct_step_from_db passed the same
# database object always return the same StepObject, e.g. the same reference,
# for the duration of the StepFactory instance.
class StepFactory
  def get_step_from_db_id(db_step_id) 
    get_step_from_db_object(Step.find(db_step_id))
  end

  def get_step_from_db_object(db_step)
    unless @steps.has_key?(db_step.id)
      @steps[db_step.id] = construct_new_step(db_step)
    end
    
    @steps[db_step.id]
  end

  private:
  def construct_new_step(db_step)
    equipment = Set[]
    unless db_step.equipment.burner == 0
      equipment << :BURNER
    end
    unless db_step.equipment.oven == 0
      equipment << :OVEN
    end
    unless db_step.equipment.burner == 0
      equipment << :MICROWAVE
    end
    unless db_step.equipment.burner == 0
      equipment << :SINK
    end
    unless db_step.equipment.burner == 0
      equipment << :TOASTER
    end

    immediate_prereq = nil
    preheat_prereq = nil
    prereqs = Set[]
    db_step.step_mappers.each do |step_mapper|
      prereq = get_step_from_db_id(step_mapper.prereq_id)

      prereqs << prereq

      if step_mapper.immediate_prereq
        immediate_prereq = prereq
      end

      if step_mapper.preheat_prereq
        preheat_prereq = prereq
      end
    end

    StepObject.new(db_step.description, db_step.time, db_step.attentiveness,
                   db_step.recipe_id, equipment, prereqs, immediate_prereq, 
                   preheat_prereq)
  end
end
