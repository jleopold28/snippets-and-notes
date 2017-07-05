$add = (5 + 5) * 2
$subtract = (15 - 3) / 2
$modulo = 7 % 2
$left = 4 << 1
$right = 4 >> 1
*['foo', 'bar', 'baz']
*(['foo', 'bar', 'baz'] << 'foobar')
*(['foo', 'bar', 'baz'] << 'foobar' + ['foobaz', 'barbaz'])
*(['foo', 'bar', 'baz'] << 'foobar' + ['foobaz', 'barbaz'] - 'foobar' - 'foobaz' - 'barbaz')
{ one => 1, two => 2 } + { three => 3 }
{ one => 1, two => 2 } + { three => 3 } - 'two'
