# module for managing the example application
class example {
  ['pos', 'svcs'].each |$instance| {
    file { "C:/abc/${instance}/example/web.config":
      ensure  => file,
      content => template('example/web_config.erb'),
    }
  }
}
