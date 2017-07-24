augeas { 'httpd':
  context => '/files/home/matt/git_repos/snippets-and-notes/puppet/puppet-advanced/3.9/apache.conf',
  changes => [
    'ins service after port',
    'set service httpd',
    'set nproc 65535',
    'rm Apache'
  ]
}
