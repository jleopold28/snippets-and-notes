# TODO: puppet::warn/error/log for stuff; doublecheck default arg value; cache vault connection; convert keys to syms?; return type; also enable write single value (not hash); values should have sym keys; input checking
# Writes a secret to Vault.
Puppet::Functions.create_function(:vault_write) do
  # Writes a secret to Vault.
  # @param [String] secret The secret to write.
  # @optional_param [Hash] values The values to write in the secret.
  # @optional_param [String] yaml_config Optional yaml config file for Vault connection.
  # @return [Undef] Returns Undef.
  # @example Write a secret.
  #   vault::write('secret/bacon', { 'cooktime' => '11', 'delicious' => true }) => #<Vault::Secret lease_id="">
  dispatch :read do
    param 'String', :secret
    optional_param 'Hash', :values
    optional_param 'String', :yaml_config
    return_type 'Undef'
  end

  def read(secret, values = {}, yaml_config = '/etc/puppetlabs/puppet/vault.yaml')
    require 'vault'
    require 'yaml'

    # read in yaml config
    config_hash = YAML.safe_load(File.read(yaml_config), [Symbol])

    Vault.configure do |config|
      # The address of the Vault server, also read as ENV["VAULT_ADDR"]
      config.address = config_hash[:address] unless config_hash[:address].nil?
      # The token to authenticate with Vault, also read as ENV["VAULT_TOKEN"]
      # user provided token
      if !config_hash[:token].nil?
        config.token = config_hash[:token]
      # user requests to generate a token specifically for this request
      elsif !config_hash[:generate_token].nil? && config_hash[:generate_token]
        # Request new access token as wrapped response where the TTL of the temporary token is 120s
        wrapped = Vault.auth_token.create(wrap_ttl: '120s')
        # Unwrap wrapped response for final token using the initial temporary token.
        config.token = Vault.logical.unwrap_token(wrapped)
      end

      # Proxy connection information, also read as ENV["VAULT_PROXY_(thing)"]
      config.proxy_address = config_hash[:proxy_address] unless config_hash[:proxy_address].nil?
      config.proxy_port = config_hash[:proxy_port] unless config_hash[:proxy_port].nil?
      config.proxy_username = config_hash[:proxy_username] unless config_hash[:proxy_username].nil?
      config.proxy_password = config_hash[:proxy_password] unless config_hash[:proxy_password].nil?
      # Custom SSL PEM, also read as ENV["VAULT_SSL_CERT"]
      if !config_hash[:ssl_pem_file].nil?
        config.ssl_pem_file = config_hash[:ssl_pem_file]
      # As an alternative to a pem file, you can provide the raw PEM string, also read in the following order of preference:
      # ENV["VAULT_SSL_PEM_CONTENTS_BASE64"] then ENV["VAULT_SSL_PEM_CONTENTS"]
      elsif !config_hash[:ssl_pem_contents].nil?
        config.ssl_pem_contents = config_hash[:ssl_pem_contents]
      # double alternatively, you can utilize a ca cert instead of a pem
      elsif !config_hash[:ssl_ca_cert].nil?
        config.ssl_ca_cert = config_hash[:ssl_ca_cert]
      end
      # Use SSL verification, also read as ENV["VAULT_SSL_VERIFY"]
      config.ssl_verify = config_hash[:ssl_verify] unless config_hash[:ssl_verify].nil?
      # Timeout the connection after a certain amount of time (seconds), also read
      # as ENV["VAULT_TIMEOUT"]
      config.timeout = config_hash[:timeout] unless config_hash[:timeout].nil?
      # It is also possible to have finer-grained controls over the timeouts, these
      # may also be read as environment variables
      config.ssl_timeout = config_hash[:ssl_timeout] unless config_hash[:ssl_timeout].nil?
      config.open_timeout = config_hash[:open_timeout] unless config_hash[:open_timeout].nil?
      config.read_timeout = config_hash[:read_timeout] unless config_hash[:read_timeout].nil?
    end

    # TODO cleanup: request new token with approle identities
    unless config_hash[:approle].nil?
      token = Vault.auth.approle(Vault.approle.role_id(config_hash[:approle]), Vault.approle.create_secret_id(config_hash[:approle]).data[:secret_id])
      Vault.token = token.auth.client_token
    end

    # check if Vault is sealed
    raise 'Vault is currently sealed.' if Vault.sys.seal_status.sealed?

    # connect to Vault
    Vault.with_retries(Vault::HTTPConnectionError, Vault::HTTPError, Vault::HTTPClientError, Vault::HTTPServerError, attempts: 2, base: 0.05, max_wait: 2.0) do |attempt, except|
      warn "Received exception #{except} from Vault on attempt number #{attempt}." unless except.nil?
      # return secret value
      Vault.logical.write(secret, values)
    end
    
    nil
  end
end
