service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => "pe-internal-dashboard\nmaster\n*",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}

package { 'git': ensure => latest }

# TODO: octocatalog-diff needs ruby-devel or gcc or something
['puppet-check', 'rake', 'rspec-puppet-init', 'serverspec-init', 'puppet-lint'].each |$bin| {
  file { "/usr/local/bin/${bin}":
    ensure => link,
    target => "/opt/puppetlabs/puppet/bin/${bin}",
  }
}

['puppet-check', 'reek', 'rspec-puppet', 'serverspec'].each |$gem| {
  exec { "/opt/puppetlabs/puppet/bin/gem install --no-document ${gem}": }
}

file { ['/etc/puppetlabs/code', '/etc/puppetlabs/r10k']:
  owner   => 'vagrant',
  recurse => true,
}
