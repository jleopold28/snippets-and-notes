Integer[0,11].slice(3) |Tuple $tuple| {
  notify { String($tuple): }
}

'world'.slice(1) |Tuple $char| {
  notify { String($char): }
}
