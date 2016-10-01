#Ensure puppet daemon off
service { 'puppet':
  ensure => stopped,
  enable => false,
}

#Apply classes if there are any to be applied
if hiera('classes', false) {
  lookup('classes', Array[String], 'unique').include
}
else {
  notify { 'empty catalog': }
}

#If the node is completely undefined according to the facts and/or not found in the Hiera ENC then do nothing
node default {}
