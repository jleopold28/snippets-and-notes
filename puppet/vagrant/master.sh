#!/bin/sh
# Workarounds for erroneous vagrant-pe_build behavior regarding rsync.
mkdir -p /vagrant/.pe_build/{post-install,answers}
cp /vagrant/master.pp /vagrant/.pe_build/post-install/master.pp
cp /vagrant/answers.txt /vagrant/.pe_build/answers/master.txt
tar -xzf /vagrant/puppet-enterprise-2016.4.9-el-7-x86_64.tar.gz -C /vagrant/.pe_build/
