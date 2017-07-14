module OctocatalogDiff
  class Config
    def self.config
      settings = {}

      settings[:hiera_config] = '/etc/puppetlabs/code/environments/production/hiera.yaml'
      settings[:hiera_path] = '/etc/puppetlabs/code/environments/production/hieradata'

      settings[:puppetdb_url] = 'https://puppet.local:8081'
      settings[:puppetdb_ssl_ca] = '/etc/puppetlabs/puppetdb/ssl/puppet.local.cert.pem'

      settings[:storeconfigs] = false
      settings[:puppet_binary] = '/usr/local/bin/puppet'
      settings[:bootstrapped_to_dir] = '/etc/puppetlabs/code/environments/production'

      settings
    end
  end
end
