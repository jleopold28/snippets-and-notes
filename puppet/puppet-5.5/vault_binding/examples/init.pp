notify { vault_read("secret/${::environment}/puppet/test", $field, "/etc/puppetlabs/puppet/${::environment}_vault.yaml"): }
