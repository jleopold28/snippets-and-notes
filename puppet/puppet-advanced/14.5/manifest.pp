$space = ['a', 'b', 'c'].reduce('Hello') |String $memo, $element| {
  "${memo}${element}"
}

notify { $space: }

$convert = [1, 2, 3].reduce({}) |Hash $memo, $element| {
  { $element => 'foo' } + $memo
}

notify { String($convert): }

$other = { one => 1, two => 2 }.reduce |$memo, $value| {
  [$memo[1] + $value[1], "${memo[0]}${value[0]}"]
}

notify { String($other): }
