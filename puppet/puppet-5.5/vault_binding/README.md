### Vault Bindings

Provides Vault bindings to Puppet via Hiera 5, `vault_read`, and `vault_write`.

```
---
version: 5

hierarchy:
  - name: 'Hiera-Vault Lookup'
    lookup_key: hiera_vault
    options:
      confine_to_keys:
        - '^puppet_.*' #TODO
      ssl_verify: true
      address: https://vault.foobar.com:8200
      token: <insert-your-vault-token-here>
      default_field: value
      mounts:
        generic:
          - secret/%{::environment}/puppet/ #TODO
```

```
vault write <mount['generic']><value of name key in lookup function (affected by confine_to_keys)> <default_field>=<puppet lookup and vault read return>
vault write puppet/common/vault_notify value=hello_123
```

```puppet
lookup({'name' => 'vault_notify', 'value_type' => String, 'default_value' => 'No Vault Secret Found', 'merge' => 'first'}) #=> 'hello_123'
Sensitive(...) #=> redacted
```
