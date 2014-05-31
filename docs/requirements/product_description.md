# Product Description

Lattice is a web app that combines multiple recipes. It combines steps from multiple recipes into an easy-to-follow list that aims to finish all of the recipes at the same time while efficiently using all of the user’s kitchen tools and appliances.

## Target Audience

Lattice will appeal to amatuer chefs who love cooking, especially meals with several dishes. Anyone who has cooked a Thanksgiving dinner knows how challenging it is to coordinate multiple dishes in the kitchen and will appreciate a simpler way to organize their work. Professional chefs, conversely, don’t need an application to tell them how to cook many dishes at once. They have enough experience to do it easily themselves.

## Problems Lattice Solves

When preparing several dishes at the same time, people may take more time than is actually needed or finish one dish after another has already gone cold. Combining several recipes into a single list of steps provides users with a more efficient, simple workflow that guarantees all of the dishes come out at as close to the same time as possible.

## Strengths and Weaknesses of Competitors

Many recipe websites and apps exist; allrecipes.com has most of the features of these kinds of apps.

Its most significant strength is the number of recipes and users it has. A cooking application needs users to submit and rate recipes, but needs recipes to attract users, so creating that base is a critical and difficult step. Allrecipes.com also allows users to specify the number of servings they want to make of a particular recipe and create shopping lists of ingredients for any number of recipes.

Allrecipes.com has no way to combine recipes, however, which is the critical feature of our implementation. It also has a cluttered interface that makes navigation confusing.

The only direct competition Lattice has is YumvY, a cooking web app and Win8 app that combines multiple recipes. Instead of combining all the steps up-front, YumvY shows up for four chefs one step at a time, basing what step to show on what has been completed so far. It also allows chefs to choose to postpone steps. These features allow the app to be flexible; a step taking more or less time than expected doesn’t throw a wrench in the cooking schedule.

YumvY also has integrated timers. When a chef completes some steps, a timer automatically starts with an appropriate duration, saving the chef the trouble of setting one himself. When the timer goes off, a notification tells the chef what to do next.

In contrast to allrecipes.com, YumvY has a clean, simple interface.

The most significant disadvantage of YumvY is it relies heavily on interaction with a phone, tablet, or computer. Chefs must click on UI buttons to move through the recipe and be able to see the screen to read steps and receive timer notifications.

YumvY also has a limited recipe selection and no way for users to upload their own recipes.

## Unique Lattice Features

The main difference between websites like allrecipes.com and Lattice is that our web app allows users to combine recipes.

The most important difference between YumvY and Lattice is that Lattice allows users to upload their own recipes and see recipes others have uploaded. This allows the recipe database to grow with the user base, as opposed to YumvY whose database is based on employees entering recipes manually in an internal format.

Another significant difference is that Lattice prepares the combined recipe up-front, allowing users to see the whole recipe before starting, and print it if desired.

Lattice also knows whether a particular step can be interrupted, so it knows not to tell a chef to start stuffing a turkey if they’re going to need to take something out of the oven in thirty seconds. YumvY’s timers can go off at any time during any step, requiring attention from the chefs.

## Major Features

*   Upload custom recipes through the web app by inputting specific features of each step:
    *   How long it takes
    *   What kitchen tools and appliances it uses
    *   Whether the step requires all, some, or none of the chef’s attention
    *   What steps need to be completed before starting this one
    *   Additional details in a notes section for the chef
*   User accounts for protecting private recipes
*   Search for recipes, either public recipes or a user’s own private recipes
*   Combine any number of recipes such that the combined meal:
    *   Finishes each dish at as close to the same time as possible
    *   Efficiently uses the chef’s time and kitchen resources
*   Specify the number of chefs working on the same meal
*   Custom kitchen settings
*   Edit and delete recipes

## Stretch Features

*   Set when each dish should be finished. Appetizers should come out half an hour before entrees, for example
*   Intelligently scale recipes for different numbers of servings
*   Upload images for custom recipes
*   Pretty print version of meal schedules

## Non-funtional Requirements

*   The time it takes Lattice to create a combined recipe from two recipes must be less than five seconds.
*   The time it takes to return recipe search results must be less than a second.
*   An average user inputting an average recipe into Lattice must take less than five minutes.
*   Private recipes must be securely hidden from other users.

## Documentation Plan

### Tutorial

There is a tutorial accessible from our menu bar, as well as a link to that tutorial on the Add Recipe page. This tutorial contains example snippets from the Add Recipe page with detailed instructions on how to fill out our recipe form.

### Mouse over Text

At multiple places on our Add Recipe page, there are mouse over tooltips to explain and give brief examples of how to fill out particularly confusing part of the form. This should be especially helpful to users who do not read the tutorial, but misinterpret our intentions.

### About/FAQ

Our About page includes a general guide to our website and its purpose. It advertises our general features such that our users can understand the basic idea of how and why they should use our website, before they start messing around with forms and searches. This gives our users a general idea of what to expect and an idea of the flow they should take through our website for the best experience possible. This is also where any future updates to the site (such as new features) would be advertised.

The About page also includes a brief FAQ, to be updated based on user feedback for questions that may be relevant to other users and are not caused by a fault in the design.
