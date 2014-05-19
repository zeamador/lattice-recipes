# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stepCounter = 0

# Handle event when a step field is added
$(document).on('nested:fieldAdded:steps', (event) ->
  field = event.field
  # increment step counter, set step number field to value of counter,
  # and make the field disabled so users cannot spuriously modify it.
  stepCounter++
  # select step number input in field
  # by selecting where name ends with [step_number]
  stepNum = field.find("input[name$='[step_number]']")
  stepNum.val(stepCounter.toString())
  stepNum.prev(".stepnum").html(stepCounter.toString())
)

# Handle event when a step field is removed
$(document).on('nested:fieldRemoved:steps', (event) ->
  # decrement step counter
  stepCounter--
  field = event.field
  # iterate through all fields after the removed step
  # and decrement their step numbers.
  while ((field = field.next("div.fields")).length)
    stepNum = field.find("input[name$='[step_number]']")
    value = parseInt(stepNum.val()) - 1
    stepNum.val(value.toString())
    stepNum.prev(".stepnum").html(value.toString())
)
