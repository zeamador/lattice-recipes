# recipes.js.coffee
# Hooks for the recipe input form.

stepCounter = 0
animLength = 250

# Set page loaded handler for each way the page could be loaded
$(document).on('page:load', -> onPageLoad()) # for turbolinks
$(document).ready(-> onPageLoad()) # for normal page load

# Do stuff once page is loaded
onPageLoad = () ->
  # reset step counter and add the first step to the page
  stepCounter = 0
  $("#steps_container").find(".add_nested_fields").click()
  # add validation handler to form
  $("#new_recipe").submit(-> validateRecipeForm())

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
  # animate removal
  field.show().slideUp(animLength)
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
)

# Handle event when prereq is added
$(document).on('nested:fieldAdded:step_mappers', (event) ->
  event.field.hide().slideDown(animLength)
)

# Handle event when prereq is removed
$(document).on('nested:fieldRemoved:step_mappers', (event) ->
  event.field.show().slideUp(animLength)
)

# Validate the recipe form data
validateRecipeForm = () ->
  title = $("#recipe_title").value
  if (title == undefined || title == null || title == "")
    alert("Title can't be empty")
    return false
  tags = $("#recipe_tags").value
  if (tags == undefined || tags == null || tags == "")
    alert("Tags can't be empty")
    return false
  ingredients = $("#recipe_ingredients").value
  if (ingredients == undefined || ingredients == null || ingredients == "")
    alert("Ingredients can't be empty")
    return false
  stepCount = 0
  steps = $("#steps_container").find("div.fields")
  steps.each(->
    # only validate if the step hasn't been removed
    if (this.find("input[name$='[_destroy]']").value != "1")
      stepCount++
      description = this.find("textarea[name$='[description]']")
      if (description == undefined || description == null || description == "")
        alert("Description can't be empty")
        return false
      time = this.find("input[name$='[time]']")
      if (time == undefined || time == null || time == "")
        alert("Time can't be empty")
        return false
  )
  if (stepCount == 0)
    alert("Must have at least one step")
    return false
  return true

