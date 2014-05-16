#!/bin/bash

# install dependencies for Ruby
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

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
sudo apt-get install nodejs

gem install rails

rbenv rehash

# set up postgres for production
sudo apt-get install libpq-dev

# cd to the location of the script
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# install all missing gems
bundle install
