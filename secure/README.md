# Secure

## CLI Examples

### Generate Key and Nonce

`secure -g`

### Encrypt File with SSL

`secure -e -f file.yaml -k cert.key -n nonce.txt`

### Decrypt a File with SSL

`secure -d -f file.eyaml -k cert.key -n nonce.txt -t tag.txt`

## API Examples

### Encrypt

```ruby
require 'secure'

options = {}
options[:action] = :encrypt
options[:file] = '/path/to/data.txt'
options[:key] = '/path/to/cert.key'
options[:nonce] = '/path/to/nonce.txt'
encrypted_contents, tag = Secure.api(options)
```

### Decrypt

```ruby
require 'secure'

options = {}
options[:action] = :decrypt
options[:file] = '/path/to/data.txt'
options[:key] = '/path/to/cert.key'
options[:nonce] = '/path/to/nonce.txt'
options[:tag] = '/path/to/tag.txt'
decrypted_contents = Secure.api(options)
```
