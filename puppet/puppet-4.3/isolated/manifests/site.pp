#Ensure puppet daemon off
service { 'puppet':
  ensure => stopped,
  enable => false,
}

#Iteratively apply classes
if $facts['env'] == 'prod' {
  $catalog = hiera_array('classes')
  #$catalog = lookup('classes', Array[String], 'unique')
}
else {
  $catalog = hiera_array('classes') + hiera_array('extra_classes')
  #$catalog = lookup('classes', Array[String], 'unique') + lookup('extra_classes', Array[String], 'unique')
}
custom::catalog { 'Isolated': classes => $catalog }

#If the node is completely undefined according to the facts and/or not found in the Hiera ENC then do nothing
node default {}
