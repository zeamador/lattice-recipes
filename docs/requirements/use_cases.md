Lattice - Team Ares  
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw),   
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)


# Use Cases

The most important use cases of Lattice are associated with the handling of recipes, which includes adding new recipes, viewing recipes, searching for recipes, and combining recipes. Use cases also include users signing in/out their account, but signing in/out is a single interaction that only changes the sing-in state. Therefore, signing in/out is only considered as two conditions here.

## Add Recipe

1. User clicks on “Add Recipe” button in menu bar
    -   If user hasn’t signed in, system prompts sign in or register
2. System displays the “Add Recipe” web page
3. User fills in information
4. User clicks on “Create Recipe” button
5. System checks whether all required information was entered correctly
    -   If missing or invalid information, system displays the “Add Recipe” web page with information entered by user, with error messages indicating incorrect information
6. Steps 3 - 5 may repeated several times
7. System displays the recipe page of the recipe just added (Success End)

### Success End Condition:

-   Sign-in status: signed in
-   All required input is filled and correct

### Failure End Condition:

-   Error Connecting Database
-   Transaction denied when add new recipe into database
-   Fail to connect to database
-   Error Handling: System displays an error web page to state the error
-   Note: Exclude any error that occurs when any of users’ input can’t fit into database, it should be checked after Step 4 and before actual storing attempt.
    
## Search for Recipe

1. User (signed in or out) clicks "Search" button in menu bar
2. System displays a list of all public recipes on the site
3. User types something in the text box at top of page
4. User clicks on “Search” button
5. System filters the list of displayed recipes to those whose tags or title match (case-insensitve) the search query (Success End)
    -   If no recipe matches the search query, the list is empty (Success End)
 
### Success End Condition:

-   User clicks on “Search button”

### Failure end and condition: 

-   Error Connecting Database
-   Fail to connect to database
-   Error Handling: System displays an error web page to state the error

## View Recipe

1. User (signed in or out) clicks on a recipe title from the Search page, from
2. System displays the “Recipe Details” web page of the selected recipe (Success end)


