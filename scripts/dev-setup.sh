#!/bin/bash
sudo apt-get install -y rabbitmq-server redis memcacher PostgreSQL git rvm
rvm install 2.3.0
cd ../
bundle install
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
sh ./scripts/dev-init.sh
psql -c 'create database travis_ci_test;' -U postgres
rake db:migrate
rake seed