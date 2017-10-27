require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :disable_sudo, true

options = Net::SSH::Config.for(host)
options[:user] = 'root'

set :host,        options[:host_name] || ENV['TARGET_HOST']
set :ssh_options, options

describe 'Packages are installed.' do
  apache = host_inventory['platform'] == 'ubuntu' ? 'apache2' : 'httpd'

  %W[#{apache} mariadb php].each do |the_package|
    describe package(the_package) do
      it { expect(subject).to be_installed }
    end
  end
end
