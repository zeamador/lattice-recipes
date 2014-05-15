#!/bin/bash

# command line arguments: $1 is version number, $2 is version message
# example: ./deploy v0.1 "zero feature release"

# tag release and push to dev repo
git tag -a $1 -m $2
git push --tags

# push to Heroku
git pull --rebase heroku master
git push heroku master
