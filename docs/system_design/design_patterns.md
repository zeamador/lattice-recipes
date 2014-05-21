Lattice - Team Ares  
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw),   
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)


# Design Patterns Lattice Utilizes

Lattice utilizes the Factory pattern for generating a "meal" from a collection of recipes. The code for  
doing this is in app/models/meal_factory.rb and app/models/schedule_builder.rb. Meal_factory's create_meal  
method is the one that takes the recipe combination input (recipes, kitchen settings, and a number of cooks)  
and returns a newly-created meal object. Schedule_builder is a helper that does the "heavy lifting" of  
creating a schedule.

Because Lattice is a Ruby on Rails app, it utilizes the Model-View-Controller pattern throughout. This can  
be seen just by looking through the source directory tree (/apps contains /models, /views, and /controllers).  
The models represent the data model (for things like steps, recipes, and users), the views are webpages that  
display the data, and the controllers create, retrieve, update, and delete (CRUD) the models when they get  
input from the views.