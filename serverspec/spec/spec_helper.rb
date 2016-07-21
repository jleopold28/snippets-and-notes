require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :disable_sudo, true

options = Net::SSH::Config.for(host)
options[:user] = 'root'

set :host,        options[:host_name] || ENV['TARGET_HOST']
set :ssh_options, options

# set :disable_sudo, true
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'
