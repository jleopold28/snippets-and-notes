#!/usr/bin/env ruby
require 'yaml'

hash = YAML.load_file('file.yaml')
hash.select { |_, values| values['key_two'] == 'value_two' }
