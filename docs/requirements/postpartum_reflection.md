# Postpartum\* Reflection

## Features and Cuts
We implemented nearly all of the features originally listed in our SRS, as well as several that we originally marked as stretch features. However, there were also some features that we cut in order to give us time to implement the features we felt were most valuable and that our users told us would be most useful.

Recipe input was completely implemented, pretty much in the same way we originally designed it, with a few notable exceptions. We ended up not tracking ingredient quantities and units, instead simply giving the user a text box to input their ingredients. Also, our requirements originally said that each step would have a "notes" section for the user to input special notes about the step. We deemed this unnecessary and instead put a single section for notes at the end of a recipe.

We implemented recipe editing, as well, which was not mentioned in our original requirements. All the aspects of a recipe that can be set when creating a new one can be changed when editing.

Recipe search was also completely implemented as we originally planned -- users can search in all the site's recipes, or just within the recipes they have added. Private recipes, which can only be viewed by the user they were uploaded by, were also implemented.

We implemented the concept of a user's "meal", which was not clearly defined in our original requirements. A meal represents a set of recipes that the user wishes to combine into a "meal schedule", the output of our recipe combination algorithm. We also added the ability for users to customize the duration and attentiveness of the steps of the recipes in their meal before combining. These changes only happen to the copy of the recipe that exists within the user's meal, not to the original recipe.

User accounts were implemented as we planned, though we scrapped the idea of using OpenID to authenticate users and instead rolled our own simple authentication scheme, which proved to be much simpler. We also implemented user account deletion which was not in our original requirements.

Recipe combination was implemented, though we ended up not using an algorithm that produces the optimal schedule given the constraints, as it was inefficient and took too long to produce a result in many cases. Instead, we used a "short-circuiting" algorithm that chooses the first schedule that works correctly. Though this doesn't produce the optimal result, it produces pretty good results and is quite fast.

One feature we planned to support and ended scrapping was simple recipe scaling, where we would take a number of servings the user desired and scale the quantities in the ingredient list to match that scaling factor. Our users told us they would not value this feature very much, so we decided not to implement it. This was one of the reasons we made ingredients a simple text box rather than making users input the quantity and unit of each ingredient.

Some of our original stretch features we implemented, mostly related to recipe combination. As it turned out, it wasn't any harder to write the combination algorithm such that it could combine any number of recipes (not just two), or take any number of cooks rather than just one. We added the frontend functionality necessary to make this work, so our site can combine any number of recipes using any number of cooks -- though there is nothing to indicate which cook is intended to perform what steps in our output.

A stretch feature we nearly implemented but then scrapped was recipe image upload. We got it partially implemented before the release candidate, but we decided it would require more time than we had to get it finished and polished. Plus, the feature-complete release had already passed so technically we should not have been trying to add new features. We probably saved four or five developer-days worth of effort by scrapping this.

We had other stretch feature ideas that would have proven too time-intensive to implement. One of these was to let users input when they wanted recipes to be completed, so that our algorithm could output a schedule that would, for example, have the appetizer dish ready a half-hour before the main course. This would have been somewhat difficult to implement, though if we had managed to get our optimal recipe combination algorithm working to satisfaction it would have been a simple change on the backend.

Originally we planned to support recipe rating and reviews, but we decided to scrap this early on as it was relatively unimportant to the functionality of our site.

## Task Assignments
Zach ended up spending a lot of his development time writing CoffeeScript to add functionality to the recipe creation form. He implemented front-end validation for recipe creation and editing. In his capacity as project manager he also made executive decisions about what features to cut and what each member of the team worked on.

Sam spent much of her time writing tests. We did not originally assign a dedicated tester but she ended up effectively being one. She took charge of our documentation and wrote the majority of it. She also submitted the vast majority of the issues on our issue tracker.

Nick mostly wrote frontend code and stylesheets, which is pretty much what we originally planned for him to do. He wrote the code for the website sidebar, including the display of recent recipes.

Chris took ownership of the recipe combination algorithm and spent the majority of his development time implementing it. He also wrote the frontend code that generates the visualization of meal schedules.

Jake spent most of his time working things related to our database. He helped implement the classes for our data model. He also made recipe creation and editing work, getting the pages ready and connecting them to the backend.

Bessie mostly worked on user account support. She initially implemented user creation, login, and logout. She then wrote code to support private recipes, and make it so users' kitchen settings and recipes were only editable by them. She also implemented recipe searching. Late in the quarter she partially implemented recipe image upload, but this was scrapped.

\* We felt "postmortem" was too morbid. We are releasing Lattice, our development lovechild, into the open source world; this is much more akin to a birth than a death.
