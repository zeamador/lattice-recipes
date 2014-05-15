#!/bin/bash

cd ~/.rbenv/plugins/ruby-build
git pull

rbenv install 2.1.2
rbenv global 2.1.2

gem install rails
bundle install
