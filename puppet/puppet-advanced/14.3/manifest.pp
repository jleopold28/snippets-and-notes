$no_puppet = ['facter', 'hiera', 'puppet', 'puppet-enterprise'].filter |String $string| {
  $string !~ /puppet/
}

notify { $no_puppet: }

$defined = { one => '1', undef => '2' }.filter |$key, String $value| {
  $key != undef
}

notify { String($defined): }

$three = ['one', 'two', 'three', 'four', 'five'].filter |Integer $index, String $element| {
  $index <= 2
}

notify { $three: }

$hash = { facter => '3', hiera => undef, puppet => '5', puppetenterprise => '2017.2' }.filter |String $key, $value| {
  $key !~ /puppet/ and $value != undef
}

notify { String($hash): }
