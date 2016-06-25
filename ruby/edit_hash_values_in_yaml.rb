#!/usr/bin/ruby
require 'yaml'

attribute_one = %w(0001 0011 0018 0031 0036 0045 0003 0012)
attribute_two = %w(0001 0068 0160 0282 0401 0532 0002 0163)
hash = YAML.load_file('file.yaml')

attribute_one.each { |att_one| File.open("att_one_#{att_one}.lst").each_line { |prefix| hash["#{prefix.chomp}.domain"]['attribute_one'] = att_one } }
attribute_two.each { |att_two| File.open("att_two_#{att_two}.lst").each_line { |prefix| hash["#{prefix.chomp}.domain"]['attribute_two'] = att_two } }

File.open('file.yaml', 'w') { |file| Psych.dump(hash, file, indentation: 2) }
