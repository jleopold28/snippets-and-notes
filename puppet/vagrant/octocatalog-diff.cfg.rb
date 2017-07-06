module OctocatalogDiff
  class Config
    def self.config
      settings = {}

      settings[:hiera_config] = 'hiera.yaml'
      settings[:hiera_path] = 'hieradata'

      settings[:puppetdb_url] = 'https://puppet.local:8081'
      settings[:puppetdb_ssl_ca] = '/etc/puppetlabs/puppetdb/ssl/puppet.local.cert.pem'

      settings[:storeconfigs] = false
      settings[:puppet_binary] = '/usr/local/bin/puppet'
      settings[:basedir] = Dir.pwd

      settings
    end
  end
end
