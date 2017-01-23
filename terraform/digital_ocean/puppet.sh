#!/bin/sh
# prep puppet
sudo apt-get update && sudo apt-get update && sudo apt-get update && sudo apt-get install ruby -y
sudo gem install --no-document puppet
# apply puppet
sudo puppet apply -e "package { 'php': ensure => installed }"
# remove puppet
sudo gem uninstall -aIx
sudo apt-get remove ruby -y
sudo apt-get autoremove -y
