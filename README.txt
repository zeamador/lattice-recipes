Lattice - Team Ares - CSE 403
Amador (zea@uw), Chalmers (cchalm@uw), Courts (src712@uw), 
Nash (nashj2@uw), Parker (nnmp@uw), Song (bessieyy@uw)

Release website found at http://evening-plateau-1297.herokuapp.com/

To get this file, you should have run:
   git clone https://yourusername@code.google.com/p/lattice-recipes/

Before running or contributing to Lattice, you will need:
   * Ruby version 2.1.1-p76
   * Rails version 4.1.0
   * Helpful Ruby on Rails Installation Tutorial:
       * https://gorails.com/setup/ubuntu/14.04
       * Only follow instructions for Ruby and Rails installation
       * Make sure to use the correct version Ruby (2.1.1)
       * We recommend following the rbenv instructions
   * Gems listed in Gemfile (see below for common installation bug fixes)
   * Heroku (see below for detailed instructions)

To deploy a local copy of the website: 
   * $ rails server
   * go to localhost:3000 in your browser to view changes

To push to development repository:
   * after $ git add and $ git commit
   * $ git pull --rebase
   * $ git push

To push to release repository:
   * $ git pull --rebase heroku master
   * $ git push heroku master
   * Only do this when deploying!

To execute the test suite:
   * $ rake test

Nightly tests...... forthcoming

The Lattice issue tracker can be found and updated at:
   https://code.google.com/p/lattice-recipes/issues/list

Style and documentation guidelines for this project are detailed here:
   https://github.com/styleguide/ruby (style)
   http://tomdoc.org/ (documentation)

Our repository uses the standard Rails directory structure:
   http://www.tutorialspoint.com/ruby-on-rails/rails-directory-structure.htm   

Setting up Heroku:
   * Contact us cse403_ares@u.washington.edu to request server access
   * Create Heroku account using the email you sent the request from
   * Install Heroku from toolbelt.heroku.com
   * $ heroku info --app evening-plateau-1297
   === evening-plateau-1297
   Addons:        heroku-postgresql:hobby-dev
   Collaborators: aidda42@gmail.com
    		  sam.r.courts@gmail.com
                  zach.amador@gmail.com
                  ....
                  <your email>

   Git URL:       git@heroku.com:evening-plateau-1297.git
   Owner Email:   jakenash23@gmail.com
   Region:        us
   Repo Size:     784k
   Slug Size:     22M
   Stack:         cedar
   Web URL:       http://evening-plateau-1297.herokuapp.com/
   * After cloning our Google code repository:
   * $ heroku git:remote --app evening-plateau-1297

Common Installation Bug Fixes:
   * If you see warning saying no pg_config then:
       * $ sudo apt-get install libpq-dev
   * If installing missing gems keeps failing, make sure you've done:
       * $ rbenv rehash
