### Vault Binding

Provides Vault bindings to Puppet via `vault_read` and `vault_write`.

#### vault_read

The `vault_read` function has two mandatory arguments and one optional argument.

```puppet
vault_read(<Vault key>, <Vault field>, Optional <Vault yaml config location>)
```

An example of looking up an `apikey` in Vault from `secret/puppet/common` with a yaml config at `/etc/puppetlabs/puppet/vault.yaml` would be as follows:

```puppet
vault_read('secret/puppet/common', 'apikey', '/etc/puppetlabs/puppet/vault.yaml')
```

This function can be made more robust by providing variable inputs to the function, such as the following for per-dependent Vault configuration and keys.

```puppet
vault_read("secret/${::environment}/puppet/test", $field, "/etc/puppetlabs/puppet/${::environment}_vault.yaml")
```

#### vault_write

The experimental `vault_write` function has one mandatory argument and two optional arguments.

```puppet
vault_write(<Vault key>, Optional <Vault field values>, Optional <Vault yaml config location>)
```

An example of writing a secret to Vault would be the following.

```puppet
vault_write('secret/puppet/common', { mysecret => 'password' }, '/etc/puppetlabs/puppet/vault.yaml')
```

#### Vault Config

The Vault configuration is handled with a yaml config file like the one observed below. The example file can be found in this repo at (files/vault.yaml)[files/vault.yaml].

This config file handles the authentication and connection information for Vault. You can use multiple files for different connections and authentications to the Vault server for reading and writing secrets within Puppet.

Note that the mandatory fields are `address`, `token`, and one of the `ssl` methods if `ssl_verify` is set to `true`.

```yaml
---
# vault server address
:address: https://vault.example.com:8200

# token and generate_token are mutually exclusive
:token:
:generate_token:
# generates a temporary token based on token and approle
:approle: puppet

# utilize proxy
:proxy_address:
:proxy_port:
:proxy_username:
:proxy_password:

# ssl verification enabled/disabled
:ssl_verify: true
# ssl verify methods; all are mutually exclusive
:ssl_pem_file:
:ssl_pem_contents:
:ssl_ca_cert:

# overall timeout and fine-grained timeouts
:timeout: 30
:ssl_timeout:
:open_timeout:
:read_timeout:
```

#### vault_binding Class

The `vault_binding` class provides a class for configuring and provisoning the Puppet Master with the necessary support for the Vault backend. The conditional restricts this class to only apply on the master. The `vault` gem providing the Ruby bindings to Vault is installed in both the Puppet and Puppetserver gem paths. The `file` resource can be modified to deploy the Vault yaml configuration to the default location at `/etc/puppetlabs/puppet/vault.yaml`. You can also modify the resource with a lambda iterator in conjunction with a template to provide multiple variable Vault configurations to utilize within Puppet.
