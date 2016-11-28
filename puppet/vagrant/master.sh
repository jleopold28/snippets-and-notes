#!/bin/sh
mkdir -p /vagrant/.pe_build/{post-install,answers}
cp /vagrant/master.pp /vagrant/.pe_build/post-install/master.pp
cp /vagrant/answers.txt /vagrant/.pe_build/answers/answers.txt
