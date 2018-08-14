$password = Sensitive('password')

if $facts['osfamily'] == 'windows' {
  $dir = $facts['os']['architecture'] ? {
    'x86'   => 'C:\Program Files (x86)\dir',
    'x64'   => 'C:\Program Files\dir',
    default => "C:\\Program Files (${facs['os']['architecture']})\\dir",
  }
}

registry::value { 'HKLM\SYSTEM\CurrentControlSet\Services\ServiceName\DelayedAutostart':
  ensure  => present,
  type    => dword,
  data    => '1',
  require => Service['ServiceName'],
}

$version_array = split($version, '\.')

$maj_version = $version[0, 2]

$pkg_version = regsubst($version, '-', '.')

transition { 'stop the service':
  resource   => Service['the service'],
  attributes => { ensure => stopped },
  prior_to   => Package['the package'],
}
service { 'the service':
  ensure    => running,
  subscribe => [Package['the package'], File['the config']],
  require   => Exec['postinstall fixes'],
}
