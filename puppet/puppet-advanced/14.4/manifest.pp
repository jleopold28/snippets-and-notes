$hi = ['a', 'b'].map |String $string| {
  "${string}hi"
}

notify { $hi: }

$divby2 = { 2 => 'foo', 4 => 'foo' }.map |Array[Variant[Integer, String], 2] $array| {
  Integer($array[0]) / 2
}

notify { String($divby2): }

$concat = ['one', 'two'].map |Integer $index, String $string| {
  "${string}${index}"
}

notify { $concat: }

$reverse = { 1 => 'one', 2 => 'two' }.map |Integer $key, Variant[Integer, String] $value| {
  { $value => $key }
}

notify { String($reverse): }
