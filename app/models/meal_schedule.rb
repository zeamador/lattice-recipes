# Immutable schedule of steps from multiple in recipes in a user's meal.
class MealSchedule
  attr_reader :recipes, :schedule, :length

  # Public: Initialize a Meal with a set of recipes and a schedule of steps.
  #
  # recipes - Set of Recipe objects.
  # schedule - Hash from Integer times in minutes to Sets of Steps beginning
  #            at that time.
  def initialize(recipes, schedule)
    @recipes = recipes
    @schedule = schedule

    unless schedule.nil?
      max_time = @schedule.keys.sort.reverse.first
      longest_step_length = 0
      @schedule[max_time].each do |step|
        if step.time > longest_step_length
          longest_step_length = step.time
        end
      end

      @length = max_time + longest_step_length
    end
  end

  # Public: Get a collimated version of this MealSchedule's schedule. A
  #         collimated schedule is an Array of schedules such that each schedule
  #         has no overlapping steps. In this context a schedule is a Hash of
  #         Integers to single Steps, not Arrays of Steps.
  #
  # Returns an Array of Hashes from Integer start times to Steps.
  def collimated_schedule
    # The array we're populating to return. Each column is one schedule.
    columns = []
    # A schedule of the steps that have not yet been put into a column.
    remainder = @schedule.clone
    remainder.each_key do |key|
      remainder[key] = remainder[key].clone
    end

    until remainder.empty?
      column = Hash.new
      # The next unoccupied time slot in this column. All times after this point
      # will be unoccupied.
      next_open_time = 0

      remainder.keys.sort.each do |time|
        if time >= next_open_time
          longest_step = remainder[time].max { |a, b| a.time <=> b.time }

          # Add the longest-time step at this time to the column. We take out
          # the longest step first to try to make the columns proceed from most
          # dense to least dense. In practice this seems to make the first
          # column maximally dense (no holes); not sure why it happens, but
          # that's the behavior we want.
          column[time] = longest_step

          # Remove the longest-time step from the remainder schedule, and delete
          # its key if there are no more steps at that time.
          remainder[time].delete(longest_step)
          if remainder[time].empty?
            remainder.delete(time)
          end

          # Update next_open_time to reflect the new step in the column.
          next_open_time = time + longest_step.time
        end
      end

      columns << column;
    end

    columns
  end
end
