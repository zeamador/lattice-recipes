Lattice - Team Ares - CSE 403
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw), 
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)

--Important Links--
Release Website: http://lattice-recipes.herokuapp.com/
Documentation: https://sites.google.com/site/latticerecipes/home
Requirements: https://drive.google.com/folderview?id=0BwdBeJqwUsYbSk5VYXJTNTdPa2s&usp=sharing
Software Architecture: https://drive.google.com/folderview?id=0BwdBeJqwUsYbemo2Rk1DU1BST1k&usp=sharing
GitHub Repository: https://github.com/zeamador/lattice-recipes
Issue Tracker: https://github.com/zeamador/lattice-recipes/issues
Style Guidelines: https://github.com/styleguide/ruby
Comment Guidelines:  http://tomdoc.org/

--Getting Started with Ubuntu 12.04 or Higher--
1. Make sure git and bundler are installed:
   $ git --version, if not installed: sudo apt-get install git
   $ bundle --version, if not installed: sudo apt-get install bundler
2. Clone our repository:
   $ git clone git@github.com:zeamador/lattice-recipes.git (with ssh key)
   OR
   $ git clone https://github.com/zeamador/lattice-recipes.git (with login)
3. cd into the lattice-recipes directory
4. Set up the development environment described below using this top level script:
   $ ./ubuntu-dev-env.sh
5. Check that your ruby and rails versions match those listed in the dev environment section below
   $ ruby -v
   $ rails -v

--Development Environment--
Ruby version 2.1.1-p76
Rails version 4.1.0
Sqlite3 for development
Postgresql for production

--Contributing to Lattice--
You will need to contact us cse403_ares at u dot washington dot edu to request permission to push to our development repository. If you want to be able to push to our Heroku repository and make changes to the actual release website, you will also need to set up Heroku (below). Although all documentation can be viewed through our documentation site and in lattice-recipes/docs, you will need to contact cse_403 to get permission to edit these documents.

--Setting up Heroku--
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

--Running our Test Suite--
    $ rspec spec (from within the lattice-recipes directory)

--Automated Testing--
   We are using Travis CI for automated testing. It is linked to the GitHub
   repository and will email the cse403_ares mailing list if a push breaks
   the build or causes a test to fail. Travis runs every time there is a push
   to the repository. Once you've gotten permission to push to the repo, you
   can add your email to the top level .travis.yml file to get these notifications.

--Deploying Local Copy of Website--
1. Run $ rails server
2. Go to localhost:3000 in your browser to view changes

--Pushing to Development Repository--
1. $ git add and $ git commit as appropriate
2. $ git pull --rebase
3. $ git push

--Pushing to Release Repository--
1. $ git add and $ git commit as appropriate
2. $ git tag -a v0.1 -m "zero feature release" (but with the correct version number and name)
3. $ git pull --rebase heroku master
4. $ git push heroku master
*** Only do this when deploying!
*** Make sure dev repo reflects these changes!

--Directory Structure--
Our repository uses the standard Rails directory structure:
   http://www.tutorialspoint.com/ruby-on-rails/rails-directory-structure.htm
Requirement and architecture documents are stored in lattice-recipes/docs
