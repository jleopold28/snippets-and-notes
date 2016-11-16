#!/bin/sh
yum install -y git

/opt/puppetlabs/puppet/bin/gem install --no-rdoc --no-ri puppet-check
ln -s /opt/puppetlabs/puppet/bin/puppet-check /usr/local/bin/.

echo "service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => \"pe-internal-dashboard\nmaster\n*\",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}" > /vagrant/.pe_build/post-install/master.pp
