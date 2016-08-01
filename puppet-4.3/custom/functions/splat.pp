# Converts an array into sequential tuples with each value repeated. This is NOT equivalent to a slice. This is also not technically a splat but that is the closest to what this is.
# e.g. custom::splat([1, 2, 3]) --> [[1, 2], [2, 3]]
function custom::splat(Array[Variant[String, Integer], 2] $array) {
  $array.reduce |$memo, $next| { [[$memo, $next]] }
}
