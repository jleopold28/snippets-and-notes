# TODO: puppet::warn for stuff; doublecheck default arg value; cache vault connection
# Reads a secret from Vault.
Puppet::Functions.create_function(:'vault::read') do
  # Reads a secret from Vault.
  # @param [String] secret The secret to retrieve and read.
  # @optional_param [String] yaml_config Optional yaml config file for Vault connection.
  # @return [Hash] Returns secret values.
  # @example Retrieve a secret.
  #   vault::read('secret/bacon') => { cooktime: '11', delicious: true }
  dispatch :read do
    param 'String', :secret
    param 'String', :yaml_config
    return_type 'Hash'
  end

  def read(secret, yaml_config = '/etc/puppetlabs/puppet/vault.yaml')
    require 'vault'
    require 'yaml'

    Vault.configure do |config|
      # read in yaml config
      config_hash = YAML.safe_load(yaml_config)

      # The address of the Vault server, also read as ENV["VAULT_ADDR"]
      config.address = config_hash[:address] if config_hash.key?(:address)
      # The token to authenticate with Vault, also read as ENV["VAULT_TOKEN"]
      # user provided token
      if config_hash.key?(:token)
        config.token = config_hash[:token]
      # user requests to generate a token specifically for this request
      elsif config_hash.key?(:generate_token) && config_hash[:generate_token]
        # Request new access token as wrapped response where the TTL of the temporary token is 120s
        wrapped = Vault.auth_token.create(wrap_ttl: '120s')
        # Unwrap wrapped response for final token using the initial temporary token.
        config.token = Vault.logical.unwrap_token(wrapped)
      end

      # Proxy connection information, also read as ENV["VAULT_PROXY_(thing)"]
      config.proxy_address = config_hash[:proxy_address] if config_hash.key?(:proxy_address)
      config.proxy_port = config_hash[:proxy_port] if config_hash.key?(:proxy_port)
      config.proxy_username = config_hash[:proxy_username] if config_hash.key?(:proxy_username)
      config.proxy_password = config_hash[:proxy_password] if config_hash.key?(:proxy_password)
      # Custom SSL PEM, also read as ENV["VAULT_SSL_CERT"]
      if config_hash.key?(:ssl_pem_file)
        config.ssl_pem_file = config_hash[:ssl_pem_file]
      # As an alternative to a pem file, you can provide the raw PEM string, also read in the following order of preference:
      # ENV["VAULT_SSL_PEM_CONTENTS_BASE64"] then ENV["VAULT_SSL_PEM_CONTENTS"]
      elsif config_hash.key?(:ssl_pem_contents)
        config.ssl_pem_contents = config_hash[:ssl_pem_contents]
      end
      # Use SSL verification, also read as ENV["VAULT_SSL_VERIFY"]
      config.ssl_verify = config_hash[:ssl_verify] if config_hash.key?(:ssl_verify)
      # Timeout the connection after a certain amount of time (seconds), also read
      # as ENV["VAULT_TIMEOUT"]
      config.timeout = config_hash[:timeout] if config_hash.key?(:timeout)
      # It is also possible to have finer-grained controls over the timeouts, these
      # may also be read as environment variables
      config.ssl_timeout = config_hash[:ssl_timeout] if config_hash.key?(:ssl_timeout)
      config.open_timeout = config_hash[:open_timeout] if config_hash.key?(:open_timeout)
      config.read_timeout = config_hash[:read_timeout] if config_hash.key?(:read_timeout)
    end

    raise 'Vault is currently sealed.' if Vault.sys.seal_status.sealed?

    Vault.with_retries(Vault::HTTPConnectionError, Vault::HTTPError, Vault::HTTPClientError, Vault::HTTPServerError, attempts: 2, base: 0.05, max_wait: 2.0) do |attempt, except|
      warn "Received exception #{except} from Vault on attempt number #{attempt}."
      Vault.logical.read(secret).data
    end
  end
end
