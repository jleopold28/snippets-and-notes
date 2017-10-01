#custom::catalog(arrays of classes)
#Iterates through classes by order specified in array and establishes seqential dependencies. Declares all classes in array.
define custom::catalog(Array[String] $classes = $title) {
  $classes.each |Integer $index, String $class| {
    class { $class: }
    if $index > 0 { Class[$classes[$index - 1]] -> Class[$class] }
  }

  # TODO: declaring current class means the final class will never be declared
  #$classes.custom::splat.each |$tuple| {
  #  with(*$tuple) |$current, $next| {
  #    class { $current: }
  #    Class[$current] -> Class[$next]
  #  }
  #}
}
