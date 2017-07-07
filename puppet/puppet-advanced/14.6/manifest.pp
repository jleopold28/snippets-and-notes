$newval = with('one', 'two', 'three') |$one, $two, $three| {
  [$one, $two, $three]
}

notify { $newval: }

$add = with(1, 2, 3) |Integer $one, Integer $two, Integer $three| {
  $one + $two + $three
}

notify { String($add): }

$str2array = with('one', 'two', 'three') |String $one, String $two, String $three| {
  ["${one}${two}${three}"]
}

notify { $str2array: }
