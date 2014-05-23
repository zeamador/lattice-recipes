# Changes for Beta Release

## Requirements Changes

### Product Description

Updated description of YumvY under the Alternatives heading. Add prerequisite steps to the list of required recipe input data under the Major Features heading.

### Process

Removed the link to our deprecated documentation site.

#### Team Structure
Team structure updated with more specific roles adopted by team members. These roles differed significantly from planned roles because of the unexpected division of effort required between the various sections of the project. The algorithm turned out to be simpler than anticipated, and integration turned out to be much harder. We also decided to have a dedicated tester so that other developers could focus on these integration problems.

#### Project Schedule
Updated to reflect the progress we actually made this week for our beta release. As our roles have changed somewhat, the schedule for the rest of the project divides labor differently than previously did. 

### Customer Meetings

We added the summaries of our recent customer meeting with Isaac and Team Poseidon.

## Design Changes

### Class Layout

Changed the description of exactly three controllers to reflect the multitude of controllers we use for various interactions with the database. These controller changes had to be made because we did not understand how Rails actually works when we wrote the initial documentation.

Added more detailed descriptions of classes. Distinguished database classes from algorithm classes, which is a distinction that only emerged when we started implementing them. Added description of ScheduleBuilder and updated the description of MealFactory.

Added an explanation of our factory classes. These were not a part of our original SDS because we did not think they would be necessary. We believed we could merge the concepts of database objects and algorithm objects into a single class, but we found that to be either impossible or simply beyond our understanding of Rails.  

### Alternative Design Decisions

Added remark about the new multitude of controllers based on a better understanding of Rails and added the changes discussed in our design changes presentation.

### Design Assumptions

Removed assumption about OpenID, as we are no longer using it. Added assumption about database objects vs algorithm objects.

### Data Storage

We did not understand how databases worked in Rails when we wrote the first version of our SDS, so our actual implementation had to be different from our old documentation. The new storage design makes database relations easier and is actually possible.

### Diagrams

Class diagram in this directory updated to reflect changes to algorithm and controllers, including consolidating it into one diagram from two. The rationale for the changes depicted are explained above.
