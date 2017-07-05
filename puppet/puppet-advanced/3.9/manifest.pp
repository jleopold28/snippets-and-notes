augeas { 'httpd':
  context => '/home/matt/git_repos/snippets-and-notes/puppet/puppet-advanced/3.9/apache.conf',
  changes => [
    'ins service = httpd after port',
    'set nproc 65535',
    'rm Apache'
  ]
}
