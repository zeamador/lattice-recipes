# Use Cases

The most important use cases of Lattice are associated with recipes, meals, and kitchens. Users can also sign up, sign in and out, and edit their password, but these later use cases are considered trivial and are not included here.

## Recipes

### Add Recipe

1. User clicks on “Add Recipe” button in menu bar.
    -   If user hasn’t signed in, system prompts sign in or register.
2. System displays the “Add Recipe” web page.
3. User fills in information.
4. User clicks on “Create Recipe” button.
5. System checks whether all required information was entered correctly.
    -   If missing or invalid information, system displays the “Add Recipe” web page with information entered by user and appropriate error messages.
6. Steps 3 - 5 may repeated several times.
7. System displays the recipe page of the recipe just added (Success End)
    
### Search for Recipe

1. User (signed in or out) clicks "Search" button in menu bar.
2. System displays a list of all public recipes on the site.
3. User types something in the text box at top of page.
4. User clicks on “Search” button.
5. System filters the list of displayed recipes to those whose tags or title match (case-insensitve) the search query (Success End)
    -   If no recipe matches the search query, the list is empty (Success End)

### View Recipe

1. User (signed in or out) clicks on a recipe title from the Search page, from the Latest Recipes sidebar, or the My Recipes page.
2. System displays the Recipe Details web page of the selected recipe (Success End)

### Edit Recipe

1. User (signed in) clicks on the title of a recipe that they personally added.
2. System displays the Recipe Details web page of the selected recipe, with visible "Edit Recipe" and "Delete Recipe" buttons at the bottom of the page. The buttons are not there if the current user was not the one who uploaded this recipe.
3. User clicks "Edit Recipe".
4. System displays the Add Recipe form, pre-populated with the selected recipe's information. The add and remove step buttons are hidden.
5. User edits fields as appropriate.
6. User clicks "Update Recipe".
7. System checks whether all required information was entered correctly
    -   If missing or invalid information, system displays the “Add Recipe” web page with information entered by user and appropriate error messages
8. Steps 5 - 7 may repeat several times.
9. System displays the updated recipe page (Success End)

### Delete Recipe

1. User (signed in) clicks on the title of a recipe that they personally added.
2. System displays the Recipe Details web page of the selected recipe, with visible "Edit Recipe" and "Delete Recipe" buttons at the bottom of the page. The buttons are not there if the current user was not the one who uploaded this recipe.
3. User clicks "Delete Recipe".
4. System displays a modal box that says "Are you sure you want to delete?".
5. User clicks "OK".
6. System deletes the recipe from the site and takes the user to the Home page (Success End)


## Meal

### Add Recipe to Meal

1. User (signed in) clicks "Add to Meal" from a recipe view page (only visible to signed in users).
2. System displays the users meal page with that recipe in it and updates the sidebar to include that recipe title in the current meal. (Success End)

### Customize Recipe in Meal

1. From their meal page, a signed in user clicks "Customize" under a recipe description.
2. System displays a customization page for that recipe with title, tags, ingredients, and all steps with their times and attentiveness visible. Only time and attentiveness fields are editable.
3. User edits time and attentivness as they see fit.
4. User clicks "Save Changes" at the bottom of the page.
5. System stays on the customization page but displays a flash message that says "Recipe updated!" (Success End)

### Remove Recipe from Meal

1. From their meal page, a signed in user clicks "Remove" under a recipe description.
2. That recipe disappears from the list of recipes on the meal page and from the list in the meal sidebar. The recipe has not been delete from the site. The user is still on the meal page (Success End)

### Combine Recipes

1. From their meal page, a signed in user clicks "Combine Recipes" on the bottom of the page.
2. The system takes them to a Combined Recipes page which displays one of the following:
    -   Meal schedule for all of the recipes in the user's meal (Success End)
    -   Error message "Recipe combination timed out. We're currently working to speed up this process, but for now, we cannot create this meal for you." (Failure End)
    -   Error message "Your recipes could not be combined because at least one of them requires a piece of kitchen equipment that you don't have." (Failure End)
    
## Kitchen

### View Kitchen Settings

1. User (signed in) clicks on "Settings" in the sidebar.
2. System displays that user's settings page which includes kitchen settings, and password/email settings (Success End)

### Edit Kitchen Settings

1. User (signed in) clicks on "Settings" in the sidebar.
2. System displays that user's settings page which includes kitchen settings, and password/email settings.
3. User edits the numbers next to equipment types in their kitchen.
4. User clicks "Update Kitchen" button.
5. System stays on the settings page and displays one of the following:
    -   A flash message that says "Kitchen updated!" (Success End)
    -   If input was negative, a browser validation warning that says "Value must be greater than or equal to 0." (Failure End)
    -   If input was blank, no flash message, and the kitchen settings are unchanged (Failure End)
