#!/bin/bash

# get the current directory, which should be the lattice-recipes directory
OLD_PWD=$(pwd)

# install dependencies for Ruby
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev -y

# install rbenv and ruby-build
cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source $HOME/.bashrc

export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

rbenv install 2.1.2
rbenv global 2.1.2

echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# install Rails
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs -y

gem install rails

rbenv rehash

# set up postgres for database
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common -y
sudo apt-get install postgresql-9.3 libpq-dev -y

sudo -u postgres createuser lattice -s

# cd to the lattice-recipes directory
cd $OLD_PWD

# install all missing gems
bundle install
