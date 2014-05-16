Lattice - Team Ares - CSE 403
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw), 
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)


-- Important Links --
Release Website: http://lattice-recipes.herokuapp.com/
Documentation: see here and lattice-recipes/docs/
GitHub Repository: https://github.com/zeamador/lattice-recipes
Issue Tracker: https://github.com/zeamador/lattice-recipes/issues
Style Guidelines: https://github.com/styleguide/ruby
Comment Guidelines: http://tomdoc.org/
Mailing List Archives: http://mailman1.u.washington.edu/pipermail/cse403_ares/
Meeting Minutes: https://docs.google.com/document/d/1ojSoqqIhGlx7bhAVIOo-5m7rPOyhUua67JkJ6k-VrRg/edit?usp=sharing


-- Development Environment --
 - Ubuntu 14.04
 - Ruby version 2.1.2
 - Rails version 4.1.0
 - Sqlite3 for development
 - Postgresql for production
 - Chrome or Firefox


-- Getting Started with Ubuntu 14.04 --
1. Make sure git and bundler are installed:
   $ git --version, if not installed: sudo apt-get install git
   $ bundle --version, if not installed: sudo apt-get install bundler
2. Clone our repository:
   $ git clone git@github.com:zeamador/lattice-recipes.git (with ssh key)
   OR
   $ git clone https://github.com/zeamador/lattice-recipes.git
3. cd into the lattice-recipes directory
4. Configure the development environment using this top level script:
   $ ./ubuntu-dev-env.sh
5. Restart shell
6. Check that your ruby and rails versions match those listed above
   $ ruby -v
   $ rails -v


-- Contributing to Lattice --
You will need to contact us cse403_ares at u dot washington dot edu to 
request permission to push to our development repository. If you want 
to be able to push to our Heroku repository and make changes to the 
actual release website, you will also need to set up Heroku (below). 
Although all documentation can be viewed as PDFs in lattice-recipes/docs, 
you will need to contact cse_403 to get permission to edit the working 
versions of these documents in our Google Drive.


-- Setting up Heroku --
1. Contact us cse403_ares at u dot washington dot edu to request server access
2. Create Heroku account using the email you sent the request from
3. Install Heroku from toolbelt.heroku.com
4. Double check that this all worked correctly by running:
   $ heroku info --app lattice-recipes
   Which should produce the following output:
        === lattice-recipes
    Addons:           heroku-postgresql:hobby-dev
    Collaborators:    < .... >
                      <your email>
    Git URL:          git@heroku.com:lattice-recipes.git
    Owner Email:      <jake's email>
    Region:           us
    Repo Size:        784k 
    Slug Size:        22M
    Stack:            cedar
    Web URL:          http://lattice-recipes.herokuapp.com/
5. After cloning our repository run:
   $ heroku git:remote -a lattice-recipes


-- Running our Test Suite --
1. cd into lattice-recipes directory
2. $ rspec spec 


-- Automated Testing --
We are using Travis CI for automated testing. It is linked to the GitHub
repository and will email the cse403_ares mailing list if a push breaks
the build or causes a test to fail. Travis runs every time there is a push
to the repository. Once you've gotten permission to push to the repo, you
can add your email to the top level .travis.yml file to get these notifications.


-- Deploying Local Copy of Website --
1. Run $ rails server
2. Go to localhost:3000 in your browser to view changes


-- Pushing to Development Repository --
1. $ git add and $ git commit as appropriate
2. $ git pull --rebase
3. $ git push


-- Deploying Release Website --
1. Make sure dev repo reflects all desired changes
2. cd into lattice-recipes directory
3. Using appropriate version number and release name:
    $ ./deploy v0.0 "release name"


-- Directory Structure --
 - In general, we are using the standard Rails directory structure:
      http://www.tutorialspoint.com/ruby-on-rails/rails-directory-structure.htm
 - lattice-recipes/app/
    - application specific code
    - divided into models, views, and controllers folders
 - lattice-recipes/docs/
    - Zip files of all versions of requirements with changelogs
    - Zip files of all versions of design documentation with changelogs
    - Beta release documentation
    - Major design patterns/principles
 - lattice-recipes/tests/
    - Text file system tests with step by step instructions
 - lattice-recipes/spec/
    - Automated unit tests
