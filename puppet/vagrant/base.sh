#!/bin/sh
systemctl stop firewalld
systemctl disable firewalld

echo "192.168.123.10 puppet.localhost puppet
192.168.123.11 node1.localhost node1
192.168.123.12 node2.localhost node2" >> /etc/hosts

echo "service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => \"pe-internal-dashboard\nmaster\n*\",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}" > /vagrant/.pe_build/post-install/master.pp
