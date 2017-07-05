class run_stages {
  stage { 'pre': before => Stage['main'] }
  stage { 'post': require => Stage['main'] }

  class { 'contains::foo': stage => 'pre' }
  class { 'contains::bar': stage => 'main' }
  class { 'contains::baz': stage => 'post' }
}
