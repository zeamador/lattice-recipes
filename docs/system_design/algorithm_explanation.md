Algorithm Explanation
=====================

This document explains the trickier parts of the recipe combination algorithm implementation. It is expected that you have read through MealScheduleFactory.rb and ScheduleBuilder.rb and understand the basics of how they are implemented. For example, if you don't know what the term "significant time" means and how significant times are used, you need to look through ScheduleBuilder.rb.

____________________________________

ScheduleBuilder
---------------

#### The Invariant
A ScheduleBuilder's @resources invariantly stores the resource state of the builder between `@current_time` and the next significant time (`get_next_time`). The operations of `add_step` and `advance_current_time` maintain this invariant in a fairly straightforward manner, but `add_step_preempt` is a little unusual.

#### Preemptively Adding Steps
`add_step_preempt` adds a step such that it **starts at the next significant time**. The method moves `@current_time` to where this step will end, calls `add_step` to do the actual adding, and then restores `@current_time`. Notably, this **does not add a significant time** for the new step's end time. From the perspective of the builder's resource invariant, the step's length is the size of the entire invariant section at the time it was added. The demandingness of the step is thus **overstated**, which allows us to guarantee that the ScheduleBuilder will continue to produce valid shedules.

*Draft: this is a stub, more detailed info and examples to come*
