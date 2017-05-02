name 'dev'
description 'This is the development environment'
cookbook 'apache', '= 0.1.5'

default_attributes(
  'author' => {
    'name' => 'default'
  }
)

override_attributes(
  'author' => {
    'name' => 'my name'
  }
)

default['author']['name'] = 'my name'
