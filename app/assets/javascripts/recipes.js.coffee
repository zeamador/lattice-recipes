# recipes.js.coffee
# Hooks for the recipe input form.

stepCounter = 0
animLength = 250

# Make the first step be added automatically when the page loads
$(document).on('page:load', -> addFirstStep()) # for turbolinks
$(document).ready(-> addFirstStep()) # for normal page load

addFirstStep = () ->
  stepCounter = 0
  $(".steps-container").find(".add_nested_fields").click()

# Handle event when a step field is added
$(document).on('nested:fieldAdded:steps', (event) ->
  field = event.field
  # hide so we can animate insertion
  field.hide()
  # increment step counter, set step number field to value of counter,
  # and make the field disabled so users cannot spuriously modify it.
  stepCounter++
  # select step number input in field
  # by selecting where name ends with [step_number]
  stepNum = field.find("input[name$='[step_number]']")
  stepNum.val(stepCounter.toString())
  stepNum.prev(".stepnum").html(stepCounter.toString())
  # hide prereq input if this is step #1
  if (stepCounter == 1)
    field.find(".prereqs").hide()
  # animate insertion
  field.slideDown(animLength)
)

# Handle event when a step field is removed
$(document).on('nested:fieldRemoved:steps', (event) ->
  # decrement step counter
  stepCounter--
  field = event.field
  # show so we can animate removal
  field.show()
  # iterate through all fields after the removed step
  # and decrement their step numbers.
  while ((field = field.next("div.fields")).length)
    stepNum = field.find("input[name$='[step_number]']")
    value = parseInt(stepNum.val()) - 1
    stepNum.val(value.toString())
    # change value in html to match form
    stepNum.prev(".stepnum").html(value.toString())
    # if this is now step #1, hide prereq input
    if (value == 1)
      field.find(".prereqs").hide()
  # animate removal
  field.slideUp(animLength)
)

# Handle event when prereq is added
$(document).on('nested:fieldAdded:step_mappers', (event) ->
  event.field.hide().slideDown(animLength)
)

# Handle event when prereq is removed
$(document).on('nested:fieldRemoved:step_mappers', (event) ->
  event.field.show().slideUp(animLength)
)
