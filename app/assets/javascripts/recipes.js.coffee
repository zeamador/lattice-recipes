# recipes.js.coffee
# Hooks for the recipe input, edit, and customize forms.

stepCounter = 0
animLength = 250

# Set page loaded handler for each way the page could be loaded
$(document).on('page:load', -> onPageLoad()) # for turbolinks
$(document).ready( -> onPageLoad()) # for normal page load

# Do stuff once page is loaded
onPageLoad = () ->
  # set step counter to number of steps on the page
  stepCounter = 0
  $(".stepnum").each( ->
    stepCounter = parseInt($(this).html())
  )
  # add a step to the page if there are no steps
  if (stepCounter == 0)
    $("#steps_container").find(".add_nested_fields").click()
  else
    # do edit form set up
    # hide prereqs for first step
    $("fieldset.step").first().find(".prereqs").hide()
    # setup equipment selector handlers
    $("select[name$='[equipment]']").change( ->
      preheat = $(this).closest(".step").find(".preheat-prereq")
      if (this.value == "oven")
        preheat.slideDown(animLength)
      else
        preheat.slideUp(animLength)
        preheat.find("input[id$='preheat_prereq']").attr("checked", false)
    )
    # hide preheat prereqs if appropriate
    $(".preheat-prereq").each( ->
      equipField = $(this).closest("fieldset.step")
                   .find("select[name$='[equipment]']")
      if (equipField.val() == "oven")
        $(this).show()
      else
        $(this).hide()
        $(this).find("input[id$='preheat_prereq']").attr("checked", false)
    )

  # add validation handler to form
  $("#new_recipe").submit( -> validateForm())
  $(".edit_recipe").submit( -> validateForm())

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
  # setup handler for equipment selection
  $("select[name$='[equipment]']").change( ->
    preheat = $(this).closest(".step").find(".preheat-prereq")
    if (this.value == "oven")
      preheat.slideDown(animLength)
    else
      preheat.slideUp(animLength)
      preheat.find("input[id$='preheat_prereq']").attr("checked", false)
  )

  # If there is more than one step, add a prereq to this step with the step
  # number of the previous step
  if (stepCounter != 1)
    # Click on the "Add Prereq" button for this step
    field.find(".add_nested_fields").click()

    prevStepNum = stepCounter - 1
    # Grab the prereq step number input field
    prereqNumField = field.find("input[name$='[prereq_step_number]']")
    # Set its value to the previous step number
    prereqNumField.val(prevStepNum.toString())

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
    fieldNum = field.find("input[name$='[step_number]']")
    value = parseInt(fieldNum.val()) - 1
    fieldNum.val(value.toString())
    # change value in html to match form
    stepNum = field.find(".stepnum")
    stepNumVal = parseInt(stepNum.html()) - 1
    stepNum.html(stepNumVal.toString())
    # if this is now step #1, hide prereq input
    if (value == 1)
      prereqs = field.find(".prereqs")
      prereqs.hide()
      # Remove all the prereqs this step had
      prereqs.find(".remove_nested_fields").click()
)

# Handle event when prereq is added
$(document).on('nested:fieldAdded:step_mappers', (event) ->
  field = event.field
  equipField = field.closest("fieldset.step").find("select[name$='[equipment]']")
  preheat = field.find(".preheat-prereq")
  if (equipField.val() == "oven")
    preheat.show()
  else
    preheat.hide()
    preheat.find("input[id$='preheat_prereq']").attr("checked", false)
  field.hide().slideDown(animLength)
)

# Handle event when prereq is removed
$(document).on('nested:fieldRemoved:step_mappers', (event) ->
  event.field.show().slideUp(animLength)
)

# Validate the recipe form data before it's sent to the server,
# so users can correct errors without having their input
# wiped out.
validateForm = () ->
  # check if this is a 'customize' page
  titleField = $("#recipe_title")
  if (titleField.length == 0)
    return validateCustomizeForm()
  else
    return validateRecipeForm()

# Validate the "customize recipe" form
validateCustomizeForm = () ->
  durations = $("input[name$='[duration]']")
  durationsValid = true
  stepCount = 0
  durations.each( ->
    stepCount++
    value = $(this).val()
    if (value == "")
      alert("Error: Missing duration for step #{stepCount}")
      return (durationsValid = false)
  )
  return durationsValid

# Validate the "add recipe" or "edit recipe" form
validateRecipeForm = () ->
  if ($("#recipe_title").val() == "")
    alert("Error: Title is empty")
    return false

  if ($("#recipe_ingredients").val() == "")
    alert("Error: Ingredients is empty")
    return false

  stepCount = 0
  stepValid = true
  steps = $("#steps_container").find("fieldset.step")
  steps.each( ->
    # only validate if the step hasn't been removed
    if ($(this).find("input[name$='[_destroy]']").val() != "1")
      stepCount++

      if ($(this).find("textarea[name$='[description]']").val() == "")
        alert("Error: Missing description for step #{stepCount}")
        return (stepValid = false)

      if ($(this).find("input[name$='[duration]']").val() == "")
        alert("Error: Missing duration for step #{stepCount}")
        return (stepValid = false)

      # ensure an attentiveness radio button is selected
      attentivenessButtons = $(this).find("input[name$='[attentiveness]']")
      attentivenessValid = false
      attentivenessButtons.each( ->
        if ($(this).is(':checked'))
          return (attentivenessValid = true)
      )
      if (!attentivenessValid)
        alert("Error: No attentiveness selected for step #{stepCount}")
        return (stepValid = false)

      # validate prereqs
      prereqValid = true
      prereqs = $(this).find("fieldset.prereq")
      immediateCount = 0
      preheatCount = 0
      prereqArr = []
      prereqs.each( ->
        # only validate if the prereq hasn't been removed
        if ($(this).find("input[name$='[_destroy]']").val() != "1")
          # get prereq number
          prereqNum = $(this).find("input[name$='[prereq_step_number]']").val()

          # fail if prereq number is empty
          if (prereqNum == "")
            alert("Error: Empty prereq number on step #{stepCount}")
            return (prereqValid = false)

          # fail if prereq number isn't less than the number of this step
          if (prereqNum >= stepCount)
            alert("Error: Prereq step #{prereqNum} is not valid for step #{stepCount}")
            return (prereqValid = false)

          # fail if this is a duplicate prereq
          if (prereqArr[prereqNum] == undefined)
            prereqArr[prereqNum] = 1
          else
            alert("Error: Prereq step #{prereqNum} is set more than once on step #{stepCount}")
            return (prereqValid = false)

          # fail if there's multiple immediate prereqs for this step
          if ($(this).find("input[name$='[immediate_prereq]']").is(':checked'))
            if (immediateCount > 0)
              alert("Error: Multiple immediate prereqs for step #{stepCount}")
              return (prereqValid = false)
            else
              immediateCount++

          # fail if there's multiple preheat prereqs for this step
          if ($(this).find("input[name$='[preheat_prereq]']").is(':checked'))
            if (preheatCount > 0)
              alert("Error: Multiple preheat prereqs for step #{stepCount}")
              return (prereqValid = false)
            else
              preheatCount++

        return true
      )

      if (!prereqValid)
        return (stepValid = false)

    return true
  )
  if (!stepValid)
    return false

  if (stepCount == 0)
    alert("Error: Recipe has no steps")
    return false

  return true

