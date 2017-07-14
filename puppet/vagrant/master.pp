service { 'pe-puppetserver': ensure => running }

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => file,
  content => "pe-internal-dashboard\nmaster\n*",
  owner   => 'root',
  group   => 'pe-puppet',
  mode    => '0644',
  notify  => Service['pe-puppetserver'],
}

package { ['git', 'cmake', 'gcc']: ensure => latest }

['puppet-check', 'rake', 'rspec-puppet-init', 'serverspec-init', 'puppet-lint', 'octocatalog-diff'].each |$bin| {
  file { "/usr/local/bin/${bin}":
    ensure => link,
    target => "/opt/puppetlabs/puppet/bin/${bin}",
  }
}

['puppet-check', 'reek', 'rspec-puppet', 'serverspec', 'octocatalog-diff'].each |$gem| {
  exec { "/opt/puppetlabs/puppet/bin/gem install --no-document ${gem}": }
}

file { ['/etc/puppetlabs/code', '/etc/puppetlabs/r10k']:
  owner   => 'vagrant',
  recurse => true,
}
