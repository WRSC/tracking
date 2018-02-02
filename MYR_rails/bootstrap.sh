#!/usr/bin/env bash
#===================== install rvm steps ==================
#add gpg
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

#use rvm to manager ruby version
sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm -y

#install ruby
sudo rvm install ruby

#install nodejs for js env
sudo apt-get install nodejs -y

#install rails
#gem install rails