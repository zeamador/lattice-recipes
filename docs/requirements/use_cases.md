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
    -   If missing or invalid information, system displays a modal dialog box with an appropriate error message and does not change the page.
6. Steps 3 - 5 may repeated several times.
7. System displays the recipe page of the recipe just added (Success End)
    
### Search for Recipe

1. User (signed in or out) clicks "Search" button in menu bar.
2. System displays a list of all public recipes on the site.
3. User types something in the text box at top of page.
4. User clicks on “Search” button.
5. System filters the list of displayed recipes to those whose tags or title match (case-insensitve) the search query (Success End)
    -   If no recipe matches the search query, the list is empty (Success End)
    
### Search for Personal Recipe

1. User (signed in) clicks "Your Recipes" button in side bar.
2. System displays a list of all public and secret recipes uploaded by the current user.
3. User types something in the text box at top of page.
4. User clicks on “Search” button.
5. System filters the list of displayed recipes to those whose tags or title match (case-insensitve) the search query (Success End)
    -   If no recipe matches the search query, the list is empty (Success End)

### View Recipe

1. User (signed in or out) clicks on a recipe title from the Search page, from the Latest Recipes sidebar, or the Your Recipes page.
2. System displays the Recipe Details web page of the selected recipe (Success End)

### Edit Recipe

1. User (signed in) clicks on the title of a recipe that they personally added.
2. System displays the Recipe Details web page of the selected recipe, with visible "Edit Recipe" and "Delete Recipe" buttons at the bottom of the page. The buttons are not there if the current user was not the one who uploaded this recipe.
3. User clicks "Edit Recipe".
4. System displays the Add Recipe form, pre-populated with the selected recipe's information.
5. User edits fields and adds and removes steps as appropriate.
6. User clicks "Update Recipe".
7. System checks whether all required information was entered correctly
    -   If missing or invalid information, system displays a modal dialog box with an appropriate error message and does not change the page.
8. Steps 5 - 7 may repeat several times.
9. System displays the updated recipe page (Success End)

### Delete Recipe

1. User (signed in) clicks on the title of a recipe that they personally added.
2. System displays the Recipe Details web page of the selected recipe, with visible "Edit Recipe" and "Delete Recipe" buttons at the bottom of the page. The buttons are not there if the current user was not the one who uploaded this recipe.
3. User clicks "Delete Recipe".
4. System displays a modal box that says "Are you sure you want to delete?".
5. User clicks "OK".
6. System deletes the recipe from the site and takes the user to the Home page. The recipe is not removed from meals it has already been added to (Success End)


## Meal

### Add Recipe to Meal

1. User (signed in) clicks "Add to Meal" from a recipe view page (button only visible to signed in users).
    -   If the user does not have all equipment required by the recipe, a modal dialog box informs the user of this and asks them if they really want to add the recipe to their meal
    -   If no, the system does not navigate away from the recipe's view page (Failure End)
2. System displays the users meal page with that recipe in it and updates the sidebar to include that recipe title in the current meal. (Success End)

### Customize Recipe in Meal

1. From their meal page, a signed in user clicks "Customize" under a recipe description.
2. System displays a customization page for that recipe with title, tags, ingredients, and all steps with their times and attentiveness visible. Only time and attentiveness fields are editable.
3. User edits time and attentivness as they see fit.
4. User clicks "Save Changes" at the bottom of the page.
    -   If the user has set invalid times, a browser message will inform them of this and will not change the page.
5. Steps 3 - 4 may repeat multiple times
6. System stays on the customization page but displays a flash message that says "Recipe updated!" (Success End)

### Remove Recipe from Meal

1. From their meal page or the meal side bar, a signed in user clicks "Remove" under a recipe description.
2. That recipe disappears from the list of recipes on the meal page and from the list in the meal sidebar. The recipe has not been delete from the site. The user is redirect to the meal page (Success End)

### Combine Recipes

1. From their meal page, a signed in user sets the number of cooks in the kitchen to a number or leaves it as 1.
2. User clicks "Combine Recipes" on the bottom of the page.
    -   If the number of cooks entered was not an integer greater than 0, a browser error displays and the user remains on the meal page.
3. Steps 1 - 2 may be repeated multiple times.
4. The system takes the user to a Combined Recipes page which displays one of the following:
    -   Meal schedule for all of the recipes in the user's meal (Success End)
    -   Error message "You don't have the equipment required to prepare this meal. Update your kitchen settings or remove the recipes marked with red exclamation points from your meal" (Failure End)
    -   Error message "Your recipe combination took too long. Our server has limited resources, so to keep it responsive for other users we cannot allow you to combine excessively complicated recipes. If this has occurred as a result of combining recipes with fewer than 60 total steps, please notify us." (Failure End)
    
## Settings

### View Kitchen Settings

1. User (signed in) clicks on "Settings" in the sidebar.
2. System displays the user's settings page which includes kitchen settings, and password/email settings (Success End)

### Edit Kitchen Settings

1. User (signed in) clicks on "Settings" in the sidebar.
2. System displays the user's settings page which includes kitchen settings, and password/email settings.
3. User edits the numbers next to equipment types in their kitchen.
4. User clicks "Update Kitchen" button.
5. System stays on the settings page and displays one of the following:
    -   A flash message that says "Kitchen updated!" (Success End)
    -   If input was negative, a browser validation warning that says "Value must be greater than or equal to 0." (Failure End)
    -   If input was blank, no flash message, and the kitchen settings are unchanged (Failure End)

### Delete User Account

1. User (signed in) clicks on "Settings" in the sidebar.
2. System displays the user's settings page which includes kitchen settings, and password/email settings.
3. User clicks on "Delete User Account" on the bottom of the page.
4. System displays a modal dialog box asking the user to confirm this action.
5. User selects "OK".
6. System goes to the Home page, the user is logged out and deleted, and all the user's secret recipes are deleted. The user's public recipes are not deleted and can now never be edited for deleted (Success End)
