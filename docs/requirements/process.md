Lattice - Team Ares  
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw),   
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)


# Process

## Software Toolset

We will be using the Ruby on Rails framework for our application. This will give us an easy way to connect  
our database, server, and website. We will be using [GitHub] (https://github.com/zeamador/lattice-recipes) as our version control system, because everyone  
on our team is already familiar with it. GitHub will provide us with an issue tracker and will integrate well  
with the continuous integration service, Travis, which we will be using for automated testing. All of our  
deliverables and important links are stored in our GitHub repository and are accessible in its README file.  
Finally, we have acquired a free server through Heroku which we will use to host our site.  

## Team Structure

Our team communicates through a UW mailing list. The archives, as well as a link to our meeting minutes are can  
be found from the top of our README. All our deliverables and working documents are in the lattice-recipes/docs/  
directory. We have scheduled meetings on Tuesdays from 9:30 to 10:30, Thursdays from 2:30 to 4:30, and Saturdays  
from 2:00 to 5:00. We have and will also scheduled additional full or partial group meetings to complete larger  
sections of the project.  

Zach is our project manager and is primarily in charge of scheduling. Sam is our scribe and takes notes at all  
of our meetings. We spent the first couple weeks discussing as a group what information we needed for our  
algorithm and brainstorming ways of getting that information from users. Nick did a large portion of the work  
designing our UI prototypes, although all group members participated in drawing the actual paper prototype,  
and Chris made digital versions of the prototype. We have divided all work on written deliverables equally by  
section.  

Moving forward, Zach and Nick will primarily work on the frontend of our application. Nick will continue with  
UI design and both will work to write the website. They will be in charge of doing frequent usability tests  
themselves, and Zach will be responsible for contacting our customers for periodic feedback. For our zero feature  
release, Nick and Zach will work (with the assistance of the backend team when appropriate) to set up a running  
rails webpage,  linked to a database. They may also try to integrate the OpenID framework into the site at this  
time.  

Chris, Bessie, Jake, and Sam will make up the backend team. As part of this, Sam, Jake, and Chris met twice  
during the design week as a small group to flesh out the project architecture. They worked to make our class  
diagrams, as well as a sequence diagram for our recipe combination algorithm. Bessie worked independently to make   
sequence diagrams for all of our other major use cases. These four members reviewed all diagrams together and made  
sure understanding of the architecture was consistent.  

Chris and Sam are responsible for designing, writing, and testing the recipe combination algorithm, while Bessie  
and Jake are responsible for designing and implementing supporting features like user accounts and the Rails  
controllers for routing messages to and from the UI.  

Chris, Jake, and Sam wrote some supporting classes (Recipe, Ingredient, Step, Equipment, Kitchen, and Meal)  
together to establish a consistent coding style, patterns for using our version control system, and give everyone  
some experience writing in Ruby. These classes have only trivial functionality, but writing them was valuable for  
everyone. Chris wrote the MealFactory, ScheduleBuilder, and Resources classes, and Sam wrote the bulk of the tests  
for the same. Bessie implemented the user accounts system, and Jake and Bessie both wrote the database classes for  
recipes, recipe steps, ingredients, and kitchens and the controllers that allows the front-end to interact with  
those items. As our lead tester, Sam has also been writing manual system tests for our major use cases and  
maintaining our documentation.  

## Schedule/Timeline

<table border="1">
<tr>
  <th>Week</th>
  <th>Tasks</th>
  <th>Deliverable</th>
</tr>
<tr>
  <td>4/21 - 4/25</td>
  <td>All: Design architecture (modularization, interfaces)</td>
  <td>Architecture (4/25)</td>
</tr>
  <td>4/28 - 5/2</td>
  <td>All: Setup development environment - version control, setup Rails, write build script<br />
  Nick: Implement skeleton UI<br />
  Zach: Link UI to backend, setup Continuous Integration<br />
  Jake: Get Heroku deployment working<br />
  Sam, Chris, Jake: Implement models (recipe, kitchen, etc.)</td>
  <td>Zero-Feature Release (5/2)</td>
</tr>
<tr>
  <td>5/5 - 5/9</td>
  <td>Nick, Zach: Implement upload, search, display pages<br />
  Jake: Implement basic upload controller functionality<br />
  Bessie: Implement user account creation and login<br />
  Sam, Chris: Work on combination algorithm</td>
  <td>None</td>
</tr>
<tr>
  <td>5/12 - 5/16</td>
  <td>Nick, Zach: Write basic recipe combination page, implement user meal sidebar display<br />
  Jake: Finish and test upload controller<br />
  Bessie: Add user meal support<br />
  Chris: Implement recipe combination<br />
  Sam: Test combination and supporting classes<br />
  All: Meet with customer (Isaac)</td>
  <td>Beta Release (5/16)</td>
</tr>
<tr>
  <td>5/19 - 5/23</td>
  <td>Nick, Zach: Implement UI for combined recipes and search, add “latest recipes” sidebar feature<br />
  Jake: Add user support, help with other back-end tasks<br />
  Bessie: Support private recipes in search<br />
  Sam, Chris: Bugfix combination<br />
  All: Do more usability testing with customers and others</td><br />
  <td>Feature-Complete Release (5/23)</td>
</tr>
<tr>
  <td>5/26 - 5/30</td>
  <td>Nick: Finish documentation<br />
  Zach: Improve error handling/error messages<br />
  All: Meet with customers to fix bugs, implement stretch features if time permits</td>
  <td>Release Candidate (5/30)</td>
</tr>
<tr>
  <td>6/2 - 6/6</td>
  <td>All: Shore up any remaining issues, finish any chosen stretch features, polish UI and documentation</td>
  <td>Version 1.0 (6/4)</td>
</tr>
<tr>
  <td>6/9</td>
  <td>All: Celebrate, cook delicious meals!</td>
  <td>Final Demo</td>
</tr>
</table>

## Risk Summary

### Using Ruby on Rails

None of our group has any prior experience with Ruby on Rails, so it is a sizeable risk to use it as the framework  
for our product. Few of our group members have any experience with the Ruby language, either. We will have to spend  
a lot of time in setting up the framework, working through tutorials, and figuring out how things are done the  
“Rails way”, and these tasks may take a lot longer than we estimate.  

Setting up and learning new tools is always difficult. There is a high likelihood we will be slowed down by problems  
with this, and the impact to our productivity will be high, since platform issues have the potential to keep our  
entire team from getting work done until they’re resolved. To reduce the chance of this putting us off our schedule,  
we have already started looking at Rails tutorials and trying to set up the framework, and getting ourselves off the  
ground will be our top priority in the coming week.  

### Inefficiency of Combination Algorithm

The algorithm for combining recipes will inevitably be complicated, as we’re trying to solve an inherently difficult  
problem (finding the optimal combination is NP-complete). It is of medium likelihood that the algorithm, once  
implemented, won’t be efficient enough to meet our non-functional requirement of having the response time for recipe  
combination be five seconds or less. The impact of this would be medium - it would make our users unhappy, but it won’t  
actually make the product unusable. We are in the process of working out the details of the algorithm, which will allow  
us to make a better estimate of how likely this is to occur.  

### Lack of Experience with Web Design

Only a few of our group members have done web design before, and even they are not very experienced. Because of this,  
implementing the front-end of our application may take more time than we anticipate. The likelihood of this happening  
is high, but the impact would be low - even if the UI implementation takes longer than expected, it does not represent  
the bulk of the work we have to do. If it becomes enough of an issue, we may move a third group member over to help with  
the UI. The hardest part of implementing the front-end will be getting started and connecting it to the back-end, which  
will be done early, so doing this will permit us to make a better estimate of the likelihood of the front-end posing  
difficulty. 

### Usability of Recipe Upload Form

Because of the way our recipe combination algorithm will work, we need a fair bit of “metadata” about the recipes in the  
app. Because recipe upload is user-facing, this means users are required to do extra work and deal with a relatively  
complex interface when inputting recipes. It is possible that our input form will be too complicated for end users, which  
could result in them making mistakes when inputting recipes, or result in them simply not wanting to use the application.  
Based on our early customer feedback, this has a low likelihood of occurring. However, the impact of it occurring would be  
very high - our product would surely fail if our users could not use (or were not willing to use) this crucial feature of  
our application. We have already taken steps to make sure this will not happen, by making mock UI’s of the input form and  
testing it on our customers, and we are fairly confident that we will be able to come up with a useable design considering  
Isaac, our TA customer, told us he thought our input form made sense and would not be unreasonably difficult to use. 

### Clarity of Meal Schedules

Once we combine recipes, we need to display the workflow of combined recipes in a way that is easy to understand. This is  
non-trivial, considering our workflow may have the cook doing multiple things at once, so just showing them a list of steps  
will not suffice to get them to understand how to carry out our instructions. This isn’t something we have spent much time  
on yet, because it’s a secondary concern relative to making sure recipe input works well and recipe combination is feasible.  
The likelihood of ending up with an unclear display of the combined recipe is low, and the impact would be medium. Having  
an unclear output won’t ruin the usability of our application, but it will significantly reduce how happy our users will be  
with the results of using our application and make them less likely to use it again. We have started thinking about ways to  
display combined recipes well, and will mock up designs for combined recipes and test them on our customers to ensure we  
make a good one.  
