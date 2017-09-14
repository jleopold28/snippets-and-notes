# databag decryption api
require 'chef/encrypted_data_bag_item'

key = Chef::EncryptedDataBagItem.load_secret(keyfile)
encrypted = File.read(encrypted_file)
decrypted = Chef::EncryptedDataBagItem.new(encrypted, key)
