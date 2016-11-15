#!/bin/sh
yum install git -y

echo "service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => \"pe-internal-dashboard\nmaster\n*\",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}" > /vagrant/.pe_build/post-install/master.pp
