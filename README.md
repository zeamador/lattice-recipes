# Lattice
## Team Ares
### CSE 403 Spring 2014
#### Team
- Zach Amador (`zea@uw`)
- Chris Chalmers (`cchalm@uw`)
- Sam Courts (`src712@uw`)
- Jake Nash (`nashj2@uw`)
- Nick Parker (`nnmp@uw`)
- Bessie Song (`bessieyy@uw`)

## Important Links
- [Release Website](http://lattice-recipes.herokuapp.com/)
- [Documentation](https://github.com/zeamador/lattice-recipes/tree/master/docs)
- [GitHub Repository](https://github.com/zeamador/lattice-recipes)
- [Issue Tracker](https://github.com/zeamador/lattice-recipes/issues)
- [Style Guidelines](https://github.com/styleguide/ruby)
- [Comment Guidelines](http://tomdoc.org/)
- [Mailing List Archives](http://mailman1.u.washington.edu/pipermail/cse403_ares/)
- [Meeting Minutes](https://docs.google.com/document/d/1ojSoqqIhGlx7bhAVIOo-5m7rPOyhUua67JkJ6k-VrRg/edit?usp=sharing)

## Development Environment
- Ubuntu 14.04
- Ruby version 2.1.2
- Rails version 4.1.0
- Sqlite3 for development
- Postgresql for production

### Supported Browsers
- Chrome 34+
- Firefox 25+

## Getting Started with Ubuntu 14.04
1. Make sure git and bundler are installed
 - ``git --version``, if not installed: ``sudo apt-get install git``
 - ``bundle --version``, if not installed: ``sudo apt-get install bundler``
2. Clone our repository
 - ``git clone git@github.com:zeamador/lattice-recipes.git`` (with ssh key)
 - or ``git clone https://github.com/zeamador/lattice-recipes.git``
3. ``cd lattice-recipes``
4. Configure the development environment using the script:
   ``./ubuntu-dev-env.sh``
5. Restart shell
6. Ensure your ruby and rails versions match those listed above:
 - ``ruby -v``
 - ``rails -v``
7. In the ``lattice-recipes/`` directory, migrate the development database
 - ``bin/rake db:migrate RAILS_ENV=development``

## Contributing to Lattice
You will need to [contact us][contact] to 
request permission to push to our development repository. If you want 
to be able to push to our Heroku repository and make changes to the 
actual release website, you will also need to set up Heroku (below).

## Setting up Heroku
1. [Contact us][contact] to request server access
2. Create Heroku account using the email you sent the request from
3. Install Heroku from toolbelt.heroku.com
4. Double check that this all worked correctly by running
   ``heroku info --app lattice-recipes``,
   which should produce the following output:  
    ```
    === lattice-recipes  
    Addons:           heroku-postgresql:hobby-dev  
    Collaborators:    < .... >  
                  <your email>  
    Git URL:          git@heroku.com:lattice-recipes.git  
    Owner Email:      <email>  
    Region:           us  
    Repo Size:        784k   
    Slug Size:        22M  
    Stack:            cedar  
    Web URL:          http://lattice-recipes.herokuapp.com/  
    ```
5. After cloning our repository, run
   ``heroku git:remote -a lattice-recipes``

## Running our Test Suite
1. ``cd lattice-recipes``
2. ``rspec spec`` 

## Automated Testing
We are using [Travis CI][travis]
for automated testing. It is linked to the GitHub repository and will email
our mailing list if a push breaks the build or causes a test to
fail. Travis runs every time there is a push to the repository. Once you've
gotten permission to push to the repo, you can add your email to the top
level .travis.yml file to get these notifications.

## Deploying Local Copy of Website
1. Run ``rails server``
2. Go to localhost:3000 in your browser to view changes

## Pushing to Development Repository
1. ``git add`` and ``git commit`` as appropriate
2. ``git pull --rebase`` 
3. ``git push``

## Deploying Release Website
1. Make sure dev repo reflects all desired changes
2. cd into lattice-recipes directory
3. Using appropriate version number and release name:
    ``./deploy.sh v0.0 "<release name>"``

## Directory Structure
In general, we are using the standard [Rails directory structure][rails].
 - `lattice-recipes/app/`
    - application specific code
    - divided into models, views, and controllers folders
 - `lattice-recipes/docs/`
    - Zip files of all versions of requirements with changelogs
    - Zip files of all versions of design documentation with changelogs
    - Beta release documentation
    - Major design patterns/principles
 - `lattice-recipes/tests/`
    - Text file system tests with step by step instructions
 - `lattice-recipes/spec/`
    - Automated unit tests

## License
MIT

[travis]:https://travis-ci.org/zeamador/lattice-recipes
[contact]:mailto:cse403_ares@u.washington.edu
[rails]:http://www.tutorialspoint.com/ruby-on-rails/rails-directory-structure.htm
