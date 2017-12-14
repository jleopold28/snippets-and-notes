# spec_helper
require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :disable_sudo, false # for iptables

options = Net::SSH::Config.for(host)
options[:keys] = %w[/home/matt/key]

case ENV['TARGET_HOST']
when '1.2.3.4', '1.2.3.5' then options[:user] = 'ubuntu'
when '1.2.3.6', '1.2.3.7' then options[:user] = 'centos'
when '1.2.3.8' then options[:user] = 'training'
else raise 'Unknown host!'
end

set :host, options[:host_name] || ENV['TARGET_HOST']
set :ssh_options, options

# tests
java = case host_inventory['platform']
       when 'ubuntu' then 'openjdk-7-jdk'
       when 'redhat', 'centos' then 'java-1.7.0-openjdk'
       end

describe package(java) do
  it { expect(subject).to be_installed }
end

%w[/opt/tomcat /opt/tomcat/webapps /opt/tomcat/webapps/theapp].each do |dir|
  describe file(dir) do
    it { expect(subject).to be_directory }
    it { expect(subject).to be_owned_by 'tomcat' }
    it { expect(subject).to be_grouped_into 'tomcat' }
    it { expect(subject).to be_writable }
  end
end

describe command('/usr/bin/curl localhost:7070') do
  its(:exit_status) { is_expected.to eq(0) }
  its(:stdout) { is_expected.to match(/tomcat/) }
end

describe process('java') do
  it { expect(subject).to be_running }
  its(:count) { is_expected.to eq(1) }
  its(:user) { is_expected.to eq('tomcat') }
  its(:args) { is_expected.to match(/tomcat/) }
end

describe 'SELinux should be disabled.' do
  it { expect(host_inventory['facter']['os']['selinux']['enabled']).to be false }
end

describe iptables do
  it { is_expected.to have_rule('-A INPUT -p tcp -m multiport --dports 7070 -m comment --comment "100 allow tomcat port access" -j ACCEPT') }
end
