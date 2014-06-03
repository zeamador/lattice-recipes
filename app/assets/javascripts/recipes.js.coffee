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
        preheat.show()
      else
        preheat.hide()
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
  stepNumField = field.find("input[name$='[step_number]']")
  stepNumField.val(stepCounter.toString())
  stepNumField.prev(".stepnum").html(stepCounter.toString())
  # hide prereq input if this is step #1
  if (stepCounter == 1)
    field.find(".prereqs").hide()
  # setup handler for equipment selection
  $("select[name$='[equipment]']").change( ->
    preheat = $(this).closest(".step").find(".preheat-prereq")
    if (this.value == "oven")
      preheat.show()
    else
      preheat.hide()
      preheat.find("input[id$='preheat_prereq']").attr("checked", false)
  )

  # Pass a number to this function to get a checkbox with that label
  checkboxTemplate = (prereqNum) -> 
    "<label>#{ prereqNum }
       <input class=\"prereq-checkbox\" type=\"checkbox\" value=\"#{ prereqNum }\">
     </label>"

  prevStepNum = stepCounter - 1

  addPrereqButton = field.find(".add_nested_fields")
  checkboxContainer = field.find(".prereqs-checkboxes")

  # Add a prereq number field and checkbox for each possible prereq
  for num in [1...stepCounter]
    addPrereqButton.click()  
    # Add a prereq number input field
    checkboxContainer[0].insertAdjacentHTML("afterbegin", checkboxTemplate(num))

  # Set the values of all the prereq number fields we just created
  for prereqNumInput, i in field.find("input[name$='[prereq_step_number]']")
    $(prereqNumInput).val((i + 1).toString())

  # Register click events for the checkboxes
  checkboxContainer.find(".prereq-checkbox").on("click", onPrereqClick)

  # Automaticall check the checkbox for the previous step.
  if stepCounter > 1
    checkboxContainer.find(".prereq-checkbox[value='#{ stepCounter - 1 }']").click()

  # animate insertion
  field.slideDown(animLength)
)

# Handle event when a step field is removed
$(document).on('nested:fieldRemoved:steps', (event) ->
  # decrement step counter
  stepCounter--
  field = event.field

  # Get step number of the removed step
  removedStepNumStr = field.find("input[name$='[step_number]']").val()
  removedStepNumVal = parseInt(removedStepNumStr)

  # animate removal
  field.show().slideUp(animLength)
  # iterate through all fields after the removed step
  # and decrement their step numbers.
  while ((field = field.next("div.fields")).length)
    stepNumField = field.find("input[name$='[step_number]']")
    stepNumVal = parseInt(stepNumField.val()) - 1
    stepNumField.val(stepNumVal.toString())
    # change value in html to match form
    stepNum = field.find(".stepnum")
    stepNum.html(stepNumVal.toString())
    # if this is now step #1, hide prereq input
    if (stepNumVal == 1)
      prereqs = field.find(".prereqs")
      prereqs.hide()
      # Remove all the prereqs this step had
      prereqs.find(".remove_nested_fields").click()

    # Get the checkbox corresponding to the removed step number
    checkboxToRemove = field.
      find(".prereq-checkbox[value='#{removedStepNumStr}']").parent()
    # Get all the checkboxes for steps after the removed step
    checkboxesToUpdate = checkboxToRemove.siblings().
      filter(() ->
        return parseInt($(this).text()) > removedStepNumVal
      )

    # Get the prereq number field corresponding to the removed step number
    numberFieldToRemove = field.find("input[name$='[prereq_step_number]']").
      filter(() ->
        return parseInt($(this).val()) == removedStepNumVal
      )
    # Get all the prereq number fields for steps after the removed step
    numberFieldsToUpdate = field.find("input[name$='[prereq_step_number]']").
      filter(() ->
        return parseInt($(this).val()) > removedStepNumVal
      )

    # Remove the checkbox for the removed step number
    checkboxToRemove.remove()
    # Update checkboxes by decrementing the values of their input elements and
    # the text in their labels
    checkboxesToUpdate.each(() ->
      newNumStr = (parseInt($(this).text()) - 1).toString()
      # Remove old prereq num label
      $(this).contents().first().remove()
      # Prepend new prereq num label
      $(this).prepend(newNumStr)
      # Update checkbox value
      $(this).find(".prereq-checkbox").attr("value", newNumStr)
    )

    # Remove the prereq number field using the remove nested fields button
    numberFieldToRemove.parent().find(".remove_nested_fields").click()
    # Update prereq number fields by decrementing their field values
    numberFieldsToUpdate.each(() ->
      $(this).val((parseInt($(this).val()) - 1).toString())
    )    
  #endwhile
)

# Prereq checkbox click event handler
onPrereqClick = (event) ->
  # The number of the prereq whose checkbox was clicked
  prereqNumStr = this.value
  prereqNumVal = parseInt(prereqNumStr)

  # The number of the step the prereq checkbox is in
  stepNumStr = $(this).closest(".step").find("input[name$='[step_number]']").
               attr("value")
  stepNumVal = parseInt(stepNumStr)

  # Get the fieldset that corresponds to the changed checkbox. We find this by
  # searching for the input field by value, then grabbing its parent.
  fieldset = $(this).closest(".prereqs").
             find("input[name$='[prereq_step_number]']").
             filter(() -> return $(this).val() == prereqNumStr).parent()

  # Enable/disable the field if the checkbox is checked/unchecked
  fieldset.attr("disabled", !this.checked)

# Get the step numbers of all steps that are descendants of the passed one
stepPrereqsAll = (stepNum) ->
  stepFieldset = $("input[name$='[step_number]'][value='#{stepNum}']").parent().
                 parent()

# Handle event when prereq is added
$(document).on('nested:fieldAdded:step_mappers', (event) ->
  field = event.field

  fieldset = field.find("fieldset.prereq")[0]
  fieldset.disabled = true;

  equipField = field.closest("fieldset.step").find("select[name$='[equipment]']")
  preheat = field.find(".preheat-prereq")
  if (equipField.val() == "oven")
    preheat.show()
  else
    preheat.hide()
    preheat.find("input[id$='preheat_prereq']").attr("checked", false)
)

# Handle event when prereq is removed
$(document).on('nested:fieldRemoved:step_mappers', (event) ->
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
  durations.each( ->
    value = $(this).val()
    if (value == undefined ||
        value == null ||
        value == "")
      alert("Duration can't be empty")
      return (durationsValid = false)
  )
  return durationsValid

# Validate the "add recipe" or "edit recipe" form
validateRecipeForm = () ->
  title = $("#recipe_title").val()
  if (title == undefined || title == null || title == "")
    alert("Title can't be empty")
    return false

  ingredients = $("#recipe_ingredients").val()
  if (ingredients == undefined || ingredients == null || ingredients == "")
    alert("Ingredients can't be empty")
    return false

  stepCount = 0
  stepValid = true
  steps = $("#steps_container").find("fieldset.step")
  steps.each( ->
    # only validate if the step hasn't been removed
    if ($(this).find("input[name$='[_destroy]']").val() != "1")
      stepCount++

      description = $(this).find("textarea[name$='[description]']").val()
      if (description == undefined || description == null || description == "")
        alert("Description can't be empty")
        return (stepValid = false)
      duration = $(this).find("input[name$='[duration]']").val()

      if (duration == undefined || duration == null || duration == "")
        alert("Duration can't be empty")
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

          # fail if prereq number isn't less than the number of this step
          if (prereqNum >= stepCount)
            alert("Prereq step #{prereqNum} is not valid for step #{stepCount}")
            return (prereqValid = false)

          # fail if this is a duplicate prereq
          if (prereqArr[prereqNum] == undefined)
            prereqArr[prereqNum] = 1
          else
            alert("Prereq step #{prereqNum} is set more than once on step #{stepCount}")
            return (prereqValid = false)

          # fail if there's multiple immediate or preheat prereqs for this step
          if ($(this).find("input[name$='[immediate_prereq]']").is(':checked'))
            if (immediateCount > 0)
              alert("Multiple immediate prereqs for step #{stepCount}")
              return (prereqValid = false)
            else
              immediateCount++
          if ($(this).find("input[name$='[preheat_prereq]']").is(':checked'))
            if (preheatCount > 0)
              alert("Multiple preheat prereqs for step #{stepCount}")
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
    alert("Must have at least one step")
    return false

  return true
