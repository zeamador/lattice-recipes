Lattice - Team Ares  
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw),   
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)


# System Design Specification

## System Architecture

### Class Layout

Lattice will be implemented using Ruby on Rails. It will consist of a multitude of Rails controllers that will  
handle user, recipe step, ingredient, recipe, kitchen, and meal creation, modification, and deletion. These  
Rails controllers will send information between users of the website and our database. They will rely on  
supporting classes to perform significant calculations like the recipe combination algorithm.

Supporting classes are divided between databases classes, which are named things like “Step” and “Recipe”, and  
algorithm classes, which are named “StepObject”, “RecipeObject”, and so on. While we believe these two concepts  
should be able to be merged, our research has not agreed, and it is easier to use this implementation for now.  
While database objects and their related algorithm objects conceptually store the same information, the format  
in which that information is stored differs between the two. Database classes inherit from ActiveRecord, which  
is the Rails class that manages database objects. They can be created, saved, and modified using various  
controller routes. Algorithm classes are typical classes that expose data and functionality we need to perform  
the recipe combination algorithm. There are five objects duplicated as both database objects and algorithm  
objects: Step, Ingredient, Recipe, Kitchen, and Meal. 

Algorithm objects are constructed from database objects for use in the recipe combination algorithm using factory  
classes. Factory classes are instantiated. For the duration of their lifetime, if one of these factories is passed  
the same database object repeatedly, identified by id, it will always return the same object reference for the  
resulting algorithm object. This allows the Step dependency graph to be built without duplicate object references  
for value-equivalent Steps.

The following are conceptual descriptions of the application’s objects, they do not describe differences in the  
ways the database objects and algorithm objects store the information:

The system enumerates a set of Equipment names like oven, burner, etc.

Steps include a description, an estimated time, a required attentiveness, a list of Equipment constants, a list  
of prerequisite steps, an optional immediate prerequisite Step (one that must be scheduled immediately before  
this Step), an optional preheat prerequisite Step (the Step that preheated the oven for this Step to use), and  
a recipe ID (a number that identifies the recipe to which this step belongs).

A Recipe includes its own recipe ID, a title, a list of Ingredients, a list of final Steps, a list of tags, a  
boolean indicating public or secret, and an optional image. A list of final Steps is the Steps in this Recipe  
that are not prerequisites for any other Steps; in other words, the last Steps in the Recipe. Every Step that  
comprises this Recipe’s instructions can be accessed by traversing the Step dependency graph starting with its  
final Steps.

A Meal is the only class that is conceptually different between the database and the algorithm. In the database,  
a Meal is just a structure associated with a user that contains a list of Recipes. In the algorithm, a Meal is  
the result of a recipe combination. The MealObject stores a list of the Recipes that went into creating it, and  
a schedule, which is a Hash from Integer start times to Steps.

The actual recipe combination algorithm is implemented inside the MealFactory class. The factory uses the  
ScheduleBuilder class internally to attempt to build every possible combination of steps. The ScheduleBuiler keeps  
track of the steps that can be scheduled at any particular moment in the schedule. When adding adding steps to the  
ScheduleBuilder, it indicates failure if adding the step is impossible. It does this using the Resources object to  
keep track of resources available at each point in the step schedule, including attentiveness and kitchen equipment,  
and by automatically attempting to schedule steps’ immediate prereqs. 

The MealFactory starts with a collection of Steps that are not prerequisites for any other Step. It branches new  
ScheduleBuilders for every possible combination of those steps, and throws out the builders that indicate failure.  
It continues with the successful builders and try every combination of the newly schedulable steps. This process  
continues until every step in the step dependency graph has been scheduled. From the successful schedules, the  
MealFactory picks those schedules for which each recipe ends at as close to the end of the combined schedule as  
possible. From those schedules it picks the shortest one and return it as the result.

### Alternative Design Decisions

Before actually sketching out our architecture, we had planned for the output of a recipe combination to be  
another recipe. We assumed that this would make it easier to implement the stretch feature of combining more  
than two recipes. During the design of our algorithm, however, we realized that we need the ability to represent  
time and concurrent steps while parallelizing recipes. We had already noticed while making our paper prototype  
that users will need more information than is normally present in a recipe for it to be clear which tasks should  
be done at the same time. This lead to the idea that a Lattice recipe contains significantly more information  
than a normal recipe, specifically a schedule. One could in theory parallelize a single recipe using our approach.  
Our Meal class represents this scheduled recipe. We also realized that our current algorithm already allows for n  
recipes per meal, thus there is no advantage to storing a combined recipe in the same format as single recipes.

The first draft of our class diagram only included one controller, the MealController. We planned to divide the  
implementation of all of our supporting data classes between two developers and have two others work on the  
MealController. After writing our sequence diagrams, however, we realized that we had three distinct use cases  
that did not make sense as part of a single controller. We also realized that the supporting classes all have  
trivial functionality and should only take a couple hours to implement. This better understanding caused us to  
rework our architecture and division of labor to its current state. This new design will better modularize the  
functionality of our application, will give each backend developer a distinct task, and will give us easy classes  
to write together as we familiarize ourselves will Ruby. We also learned later that the Rails framework encourages  
the use of a multitude of controllers, and our original plan would not have been intuitive to implement in the  
framework.

### Design Assumptions

We assume that there is no way to integrate the notions of our database objects and our conventional classes used  
for the combination algorithm. We researched this assumption but found no concrete answer as to whether or not it  
is correct. For now we will implement them as two different classes, one an ActiveRecord and the other not, with  
methods to convert between them, because we know this will work, even if there may be a better, more obscure solution.

We made assumptions about what an optimal combined recipe is. We believe, for example, that it is optimal to have  
all recipes end at as close to the same time as resources permit. We designed our algorithm around this constraint,  
but it is possible that some user would prioritize other features of a combination.

### Data Storage

We will use a database to store our data. The main data we will store are: recipes, user information, and user  
kitchen settings. The data will be stored in 8 tables called: User, Kitchen, Meal, Recipe, Ingredient, Step,  
StepMapper, and Equipment

User(name, email, password_digest, kitchen_id, meal_id)  
*   Stores information about the user and allows sessions to work, has many recipes, has one meal, has one kitchen  
Kitchen(burner, oven, microwave, sink, toaster, user_id)  
*   Stores information about resources that a user has available, belongs to users  
Meal(recipe_id)  
*   Stores recipes to be used in combinations, has many recipes, belongs to users.  
Recipe(title, secret, tags, user_id)  
*   Stores basic recipe information, has many steps, has many ingredients, belongs to users.  
Ingredient(quantity, unit, description, recipe_id)  
*   Stores basic information about ingredients, belongs to recipes  
Step(description, time, attentiveness, step_number, final_step, recipe_id)  
*   Stores detailed information about steps in a recipe, has many StepMappers, has many Equipments, belongs to recipes  
StepMapper(immediate_prereq, preheat_prereq, prereq_id, prereq_step_number, step_id)  
*   Acts as a database representation of prerequisite steps, belongs to steps.  
Equipment(burner, oven, microwave, sink, toaster, step_id)  
*   Stores information about resources that a single step uses, belongs to steps.  
	
## Process

See ../srs/process.md for our risk assessment, schedule, team structure, and documentation plan

### Test Plan

#### Unit Test Strategy

We use rspec for our unit testing, which means writing a spec file for every class we test. On the algorithm  
side, Sam wrote black-box tests for both ScheduleBuilder and MealFactory, and Chris added white-box tests once  
he was finished writing those classes. The goal was to test both the expected output as defined by the classes’  
interfaces, but also protect against potential faults as a result of their specific implementations. Bessie  
wrote her own rspec tests for the user login system, although most of that functionality will be tested using  
system tests. Jake’s back-end work will be tested with system tests, and Zach and Nick’s front-end work will be  
tested with UI tests.

#### System Test Strategy

Our system tests will be designed to guarantee that all of our controllers integrate well with each other as well  
as with the front end and the database.  These tests will need to be a concerted effort of all members of the  
back end, because they will all have specific knowledge about each of the controllers.  The focus of these tests  
is correct output and integration, so these will mainly be black box tests.  Since every member of the back end  
will have input for this set of tests, they should be developed in group meetings.  A reasonable plan would be to  
run system tests once a week in a group meeting devoted to the task and to run the tests before all the releases,  
as well.

#### Usability Test Strategy

Our usability tests will be designed to make sure our website is intuitive and provides all the functionality that  
our customers expect.  In order to guarantee coverage, we plan on arranging frequent meetings with both Team  
Poseidon and Isaac.  During these meetings, we will provide our customers with our website as it exists in its  
current state and ask them to perform certain use cases. We will take feedback from them in order to understand  
exactly what we need to fix or implement.  These tests will be done at least once a week and before each release  
version.  As the final releases approach, testing frequency will increase because the usability will change at a  
faster pace.

#### Bug Tracking

We are using Github’s issue tracker for bug tracking. This allows us to submit both bugs and enhancement requests,  
so we are using it to log unimplemented features as well as broken features.

### Coding Style Guidelines

We will be using Ruby on Rails for our project. We’ve decided to use [github’s style guidelines](https://github.com/styleguide/ruby). We will  
enforce these guidelines through informal code reviews at our weekly Tuesday morning meetings. We will also write  
our supporting classes together during week 5. This will ensure that all group members have a clear understanding  
of the guidelines before writing code on their own
