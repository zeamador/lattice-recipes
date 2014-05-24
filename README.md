# Lattice
## CSE 403 Spring 2014
### Team Ares
- Zach Amador (`zea@uw`)
- Chris Chalmers (`cchalm@uw`)
- Sam Courts (`src712@uw`)
- Jake Nash (`nashj2@uw`)
- Nick Parker (`nnmp@uw`)
- Bessie Song (`bessieyy@uw`)

## Important Links
- [Release Website](https://lattice-recipes.herokuapp.com/)
- [Documentation](https://github.com/zeamador/lattice-recipes/tree/master/docs)
- [GitHub Repository](https://github.com/zeamador/lattice-recipes)
- [Issue Tracker](https://github.com/zeamador/lattice-recipes/issues)
- [Style Guidelines](https://github.com/styleguide/ruby)
- [Comment Guidelines](http://tomdoc.org/)
- [Mailing List Archives](http://mailman1.u.washington.edu/pipermail/cse403_ares/)
- [Meeting Minutes](https://docs.google.com/document/d/1ojSoqqIhGlx7bhAVIOo-5m7rPOyhUua67JkJ6k-VrRg/edit?usp=sharing)

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
6. Ensure your ruby and rails versions match those listed below:
 - ``ruby -v``
 - ``rails -v``
7. In the ``lattice-recipes/`` directory, migrate the development database
 - ``bin/rake db:migrate RAILS_ENV=development``
 
## Development Environment
- Ubuntu 14.04
- Ruby version 2.1.2
- Rails version 4.1.0
- Sqlite3 for development
- Postgresql for production

### Supported Browsers
- Chrome 34+
- Firefox 25+

## Contributing to Lattice
You will need to [contact us][contact] to 
request permission to push to our development repository. If you want 
to be able to push to our Heroku repository and make changes to the 
actual release website, you will also need to set up Heroku (below).

### Setting up Heroku
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
   
### Viewing Local Copy of Website
1. Run ``rails server``
2. Go to localhost:3000 in your browser to view changes

### Pushing to Development Repository
1. ``git add`` and ``git commit`` as appropriate
2. ``git pull --rebase`` 
3. ``git push``

## Deploying a Release
1. Make sure dev repo reflects all desired changes
2. cd into lattice-recipes directory
3. Using appropriate version number and release name:
    ``./deploy.sh <version number> "<release name>"``
4. Draft a new release on [GitHub][releases] using the commit tagged with the above version number 
(tagged automatically by the deployment script)
    
### Accessing Old Releases
All our releases are hosted on GitHub, and can be viewed [here][releases].

### Updating Documentation
All of our developer documentation can be found and edited in this file or 
in ``lattice-recipes/docs/``. There is no product website to update when deploying a new release, but the user facing documentation in ``lattice-recipes/app/views/about/index.html.erb`` should be kept up to date. All documentation prior to the feature complete release can be accessed in ``lattice-recipes/docs/`` of our [Beta Release][beta].

## Testing

### Running Unit Tests
1. ``cd lattice-recipes``
2. ``bundle exec rspec spec`` 

### Automated Testing
We are using [Travis CI][travis]
for automated testing. It is linked to the GitHub repository and will email
our mailing list if a push breaks the build or causes a unit test to
fail. Travis runs every time there is a push to the repository. Once you've
gotten permission to push to the repo, you can add your email to the top
level .travis.yml file to get these notifications.

### Test Coverage
SimpleCov automatically runs test coverage analysis every time our test suite is 
executed. These results are stored in ``lattice-recipes/coverage/index.html``. This
file is not stored in our repo, but is recreated every time our unit tests are run.

### Running System Tests
Manual system tests are located in ``lattice-recipes/tests``. These text files
contain step by step instructions, and should be run before deployment and whenever
significant changes are made to a use case.

## Directory Structure
In general, we are using the standard [Rails directory structure][rails].
 - `lattice-recipes/app/`
    - application specific code
    - divided into models, views, and controllers folders
 - `lattice-recipes/docs/`
    - requirements documentation including feature descriptions for major releases
    - design documentation and diagrams
    - changelogs for documentation
 - `lattice-recipes/tests/`
    - text file system tests with step by step instructions
 - `lattice-recipes/spec/`
    - automated unit tests
 - `lattice-recipes/coverage`
    - only visible after running unit tests
    - contains test coverage analysis

## License
MIT

[travis]:https://travis-ci.org/zeamador/lattice-recipes
[contact]:mailto:cse403_ares@u.washington.edu
[rails]:http://www.tutorialspoint.com/ruby-on-rails/rails-directory-structure.htm
[releases]:https://github.com/zeamador/lattice-recipes/releases
[beta]:https://github.com/zeamador/lattice-recipes/releases/tag/v0.2.1
