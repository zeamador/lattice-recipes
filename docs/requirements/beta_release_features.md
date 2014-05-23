# Beta Release Features

## User Accounts

Users can create an account on Lattice and from then on sign in with that account. Accounts have kitchen settings like number of stove burners and ovens. A user can change these settings when logged in to their account.

## Upload Recipes

Users can upload their own recipes using the recipe upload form accessible from the “Upload” tab near the top of the page.

## Search for Recipes

Users, logged in or not, can use the search page, accessible from the “Search” tab near the top of the page, to search the recipe database by recipe title or recipe tags. All recipes uploaded by any users are searchable. They can view the details of specific recipes by clicking on them from the search page, and can add recipes to their meal either from the search results page or the recipe details page. Once recipes have been added to a user’s meal, they are visible in the “meal” section of the sidebar.

# Beta Release Non-Features

## Secret Recipes

All recipes are public and can be searched for and used by anyone, including anonymous users.

## Scaling Recipes

Recipes cannot be scaled to arbitrary numbers of servings. This is a stretch feature that may never be implemented.

## Combine Recipes

Users cannot yet combine recipes. The algorithm is written and tested, but it is not connected to the UI because a few  
hooks mentioned in these non-features are missing.

## Dynamic Upload Page

The recipe upload page currently has a static number of steps and ingredients that can be added. Steps can only have three prerequisites. By the feature complete release the page should have “add step” buttons implemented in javascript to allow any number of steps to be added, and similar for the other two elements.
