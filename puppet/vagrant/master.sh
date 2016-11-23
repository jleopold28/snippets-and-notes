#!/bin/sh
mkdir -p /vagrant/.pe_build/post-install

echo "service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => \"pe-internal-dashboard\nmaster\n*\",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}

package { 'git': ensure => latest }

['puppet-check', 'rake', 'rspec-puppet-init', 'serverspec-init'].each |\$bin| {
  file { \"/usr/local/bin/\${bin}\":
    ensure => link,
    target => \"/opt/puppetlabs/puppet/bin/\${bin}\",
  }
}

['puppet-check', 'reek', 'rspec-puppet', 'serverspec'].each |\$gem| {
  exec { \"/opt/puppetlabs/puppet/bin/gem install --no-rdoc --no-ri \${gem}\": }
}" > /vagrant/.pe_build/post-install/master.pp
