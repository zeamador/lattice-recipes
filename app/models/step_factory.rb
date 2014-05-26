# A StepFactory ensures that calls to construct_step_from_db passed the same
# database object always return the same StepObject, e.g. the same reference,
# for the duration of the StepFactory instance.
class StepFactory < ObjectFactory
  def initialize
    super
    @db_class = Step
  end

  private
  # See ObjectFactory
  def construct_new_object(db_step)
    immediate_prereq = nil
    preheat_prereq = nil
    prereqs = Set[]
    db_step.step_mappers.each do |step_mapper|
      prereq = get_object_from_db_id(step_mapper.prereq_id)

      prereqs << prereq

      if step_mapper.immediate_prereq
        immediate_prereq = prereq
      end

      if step_mapper.preheat_prereq
        preheat_prereq = prereq
      end
    end

    equipment = nil;
    unless db_step.equipment.empty?
      equipment = db_step.equipment.upcase.to_sym
    end

    focus = FocusTypes.const_get(db_step.attentiveness)

    StepObject.new(db_step.description, db_step.time, focus, db_step.recipe_id,
                   equipment: equipment, prereqs: prereqs, 
                   immediate_prereq: immediate_prereq, 
                   preheat_prereq: preheat_prereq)
  end
end

