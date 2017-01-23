class conjur {
  $password = conjur_fetch('matt-secrets', 'mysql-password')

  notify { $password: }
}
