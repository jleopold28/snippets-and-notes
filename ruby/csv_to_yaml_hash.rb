#!/usr/bin/ruby
require 'csv'
require 'yaml'

hash = {}
CSV.foreach('file.csv') do |col_one, _, col_three, col_four, col_five, _, col_seven, _, _, _|
  domain = /^hostname1\.(domain[3-7]{5})$/.match(col_five).captures[0]
  hash[domain] = {}
  hash[domain]['col_one'] = col_one
  hash[domain]['col_three'] = col_three.downcase unless col_three.nil?
  hash[domain]['col_four'] = col_four.downcase unless col_four.nil?
  hash[domain]['col_seven'] = col_seven.downcase unless col_seven_code.nil?
  hash[domain]['key'] = 100
  hash[domain]['key_two'] = 30
end

File.open('main.yml', 'w') do |file|
  file.write(Psych.dump(hash, indentation: 2))
end
