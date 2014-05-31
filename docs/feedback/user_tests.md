# Users

## User 1 (interviewed by Chris)
### Background
- 20-year-old male
- Graduating senior in Chemistry at UW
- Cooks ocassionally

### Tasks
- Sign up and upload a recipe from AllRecipes.com
- Search for recipes and combine a few of the ones found

## User 2 (interviewed by Bessie)
### Background
- Uses a lot of online apps
- Chinese
- Student at UW

### Tasks
- Add Recipe
- Add to meal, change kitchen settings, customize and combine meal
- Use Search and Your Recipes
- Tutorial
- Free testing

## User 3 (interviewed by Jake)
### Background
- 23 year old female
- Graduating Senior in BioChemistry and Economics at UW
- Cooks almost every day
- Taiwanese

### Tasks
- Create User, change Kitchen settings
- Add Recipe, twice
- Read Tutorial
- Edit one Recipe from that Recipe's page
- Add both Recipes to Meal and combine Meal
- Use Search to add another Recipe to Meal, combine again
- Free Exploration


## User 4  (interviewed by Zach)
### Background
- Master's student at UW in vocal performance
- Cooks regularly
- Used to reading recipes from cookbooks

### Tasks
- Had user add a simple pasta recipe
- Then add it to her meal and combine
- Also looked at tutorial


## User 5 (interviewed by Sam)
### Background
- 22 year old 
- UW student
- Does not cook regularly

### Tasks
- Had her create her own recipe
- Then edit that recipe and
- Add it to her meal twice
- Also looked at tutorial

# General Feedback and Responses

## Home page was boring and unscannable
Both our real customer, Isaac, and User 5 said that the home page did not serve its purpose. User 5 specifically said the home page was oddly small and had too much text. She said she would never read the text on the page and saw only the two hyper links in the last sentence.

### Response
We created a custom image for our welcome page to fill it out and make it more attractive. We also replaced all of our text with a single large fragment and 3 - 4 bullet points.

## Confusing Settings page
User 1 did not realize he was directed to the settings page after creating an account. 

### Response
We added a "Settings" title to this page and reorganized its content to be more readable.

## Tooltip explanations were unclear
All five users expressed confusion over at least one tooltip. We also had users request more tooltips by tags, the Add Prereq button, and by the step description box. User 2 never read the tooltips at all and most other users needed prompting to read their first tooltip.

### Response
We rewrote all of our tooltips to increase clarity, added tooltips to tags and the Add Prereq button, and added on screen instructions for Steps and Prereqs so that even people who didn't hover over the tooltip would see the text. We also changed the color of our tooltips so that they would be easier on the eyes.

## Times were excluded from recipe descriptions
User 5 did not included important times (like how long to microwave something) in the step description because there was a time field right below it.

### Response
This was not fully addressed for the Release Candidate. We did add a scale to the meal schedule so it is possible to recover times from this, but it would be best to include times with the step descriptions. This will be fixed soon.

## Tutorial would not be used
Users 1 and 2 were the only ones to open the tutorial without being prompted. All five users said that the images on the tutorial were very helpful but that the text was too verbose and that they would never read it.

### Response
We added text to the top of the Add Recipe page to prompt new users to look at the tutorial. We also added more images to the tutorial and removed over half the text next to the images.

## Unclear how to add more recipes to a meal
User 4 could not figure out how to add more recipes to a meal once she was on the Meal page.

### Response
We added instructions on the Meal page for how to add more recipes to the meal.

## Meal Schedule was not at all intuitive
All five users needed verbal explanations of the meal schedule display. Once it was explained to them, they generally liked it, except for the colors.

### Response
We added a labeled time line to the left of the schedule and color coded the step boxes by the recipe they came from. We also reorganzied how we listed recipe ingredients so that it would be clearer which recipe the ingredients corresponded to and included a color key by the recipe titles. Finally, we changed the schedule so that when you hover over a step box, the step description appears.

## Red X's for deleting look like error messages
User 1 thought that the red X by each step indicated that he had made an error while adding a recipe. User 5 was also confused by why the red X was on the left of the step.

### Response
This was not addressed for the Release Candidate, but we will move the X to the right of the step and change its color very soon. We will also add hover text over this icon that says "Delete Step".

# Overall Experience
We were generally surprised by the things our users were confused by. We expected them to initially have trouble adding prereqs and breaking up steps, but we thought that there was ample information available on the site to clarify these. What we hadn't realized was how difficult that information is to find and how little text users are willing to read. Since we already knew our intentions and the location of all our documentation, we were too biased to realize this. Having actual users look at the site was far more helpful than even our peer customers have been. Our non-cs users had much higher expectations for the product and would simply fail to complete tasks when things were unclear.
