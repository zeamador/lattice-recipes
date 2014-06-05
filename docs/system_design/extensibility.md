# Extensibility Exercise

*Let users save a meal schedule so that they can come back to it. A meal schedule should be immutable; that is, if I have saved a schedule with recipe A and someone edits recipe A, my schedule should be based on the version of recipe A that I saved.*

## Detailed Requirements

Successfully clicking the "Combine Recipes" button from the meal show page will create and save a meal schedule in the database and then redirect the user to the meal schedule show page. A failed combination will not create or save a schedule. A user's saved schedules will be accessible from the "Your Schedules" link in the right sidebar (underneath "Your Recipes"). Clicking this link with redirect the user to the meal schedule index page. This will list schedules by their recipe titles. If users select more info next to a schedule, they will also be able to see the number of cooks, kitchen settings, and date the meal schedule was created. Each entry will have a "View Schedule" button next to it that will redirect the user to the meal schedule and a delete button (with a confirmation modal box) that permanantely removes the schedule from the database. Nothing about the saved meal schedules is modifiable. The recipe titles are just text, not links to recipe show pages.

## Design Changes

### ``app/models/meal_schedule.rb``

1. Set meal schedules to inherit from ActiveRecord:  
    ``class MealSchedule < ActiveRecord::Base``
2. Add the following database relationship:  
    ``belongs_to :user``
3. Update the readable fields to:  
    ``attr_reader :recipes, :schedule, :length, :cooks, :kitchen``
4. Add serialization for complex fields:  
    ``serialize :recipes, :schedule, :kitchen``
  
### ``app/models/user.rb``

1. Add the following database relationship: 
    ``has_many :meal_schedules``

### ``db/migrate/``

1. Run ``$ rails generate migration CreateMealSchedules``
2. In the newly generated ``*create_meal_schedules.rb``, add a reference to users:  
    ``t.references :user, index: true``
3. Add columns for the length of the meal schedule and number of cooks:  
    ``t.integer :length``  
    ``t.integer :cooks``
4. Add text columns for the serialized fields:  
    ``t.text :recipes``  
    ``t.text :schedule``  
    ``t.text :kitchen``

### ``app/controllers/meal_schedule_controller.rb``

1. Move all of the logic currently in ``show`` to the ``create`` method.
2. After getting a meal schedule ``ms`` back from the meal factory, if it isn't nil, save the schedule (``ms.save``).
3. If an error occurred, redirect back to the meal show page and display that error.
4. After saving the schedule, redirect to its show page.
5. Change ``show`` to just set the local meal schedule variable:  
    ``@meal_schedule = MealSchedule.find(params[:id])``
    
### ``app/views/meal_schedules/``

1. Add an index page for meal schedules 
2. For each of the user's meal scheudles, lists titles of the recipes in the scheudule
3. There should be a "More Info" link next to those titles that hides/shows the number of cooks and kitchen settings used for that schedule. It should also show the date the schedule was created. 
4. Add a "View Schedule" button next to each meal schedule description that directs the user to that schedules show page.
5. There should also be a "Delete Schedule" button that after modal dialog confirmation permanantly deletes the entire meal schedule from the database.

### ``app/views/shared/_sidebar.html.erb``

1. Add a link underneath "Your Recipes" in the user's sidebar to "Your Schedules" that directs the user to the meal schedule index page.

### ``app/views/about/index.html.erb``

1. Add documentation to the About page that explains how saving meal schedules work.
