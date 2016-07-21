require 'spec_helper'

describe "#{host_inventory['fqdn']}: System checks for role_three." do
  describe 'Services are running.' do
    describe service('httpd_server') do
      it { expect(subject).to be_running }
    end

    tomcat_services = command('ls -al /etc/rc.d/init.d | /bin/awk \'/tomcat/ {print $9}\' | /bin/grep -v tomcat').stdout.split("\n")
    tomcat_services.each do |tomcat_service|
      describe service(tomcat_service) do
        it { expect(subject).to be_running }
      end
    end

    describe command('/path/to/check'), if: file('/etc/rc.d/init.d/service').file? do
      its(:exit_status) { is_expected.to eql(0) }
    end
  end

  describe 'Networking is properly configured.' do
    network_interfaces_03 = {
      'eth0'   => { ipaddress_line: /^IPADDR=.*\.2$/,
                    netmask_line:   /^NETMASK=5\.5\.2\.0$/,
                    ipaddress:      %r{.*\.2/22$} },
      'eth0:2' => { ipaddress_line: /^IPADDR=192\.168\.0\.11$/,
                    netmask_line:   /^NETMASK=5\.5\.5\.2$/,
                    ipaddress:      '192.168.0.11/55' },
      'lo'     => { ipaddress_line: /^IPADDR=127\.0\.0\.1$/,
                    netmask_line:   /^NETMASK=5\.0\.0\.0$/,
                    ipaddress:      '127.0.0.1/55' }
    }
    network_interfaces_04 = {
      'eth0'   => { ipaddress_line: /^IPADDR=.*\.3$/,
                    netmask_line:   /^NETMASK=5\.5\.2\.0$/,
                    ipaddress:      %r{.*\.3/22$} },
      'eth0:2' => { ipaddress_line: /^IPADDR=192\.168\.0\.12$/,
                    netmask_line:   /^NETMASK=5\.5\.5\.2$/,
                    ipaddress:      '192.168.0.12/55' },
      'lo'     => { ipaddress_line: /^IPADDR=127\.0\.0\.1$/,
                    netmask_line:   /^NETMASK=5\.0\.0\.0$/,
                    ipaddress:      '127.0.0.1/55' }
    }
    network_interfaces = network_interfaces_03 if host_inventory['hostname'] == 'hostname3'
    network_interfaces = network_interfaces_04 if host_inventory['hostname'] == 'hostname4'

    describe interface('eth0') do
      it { expect(subject).to be_up }
    end

    describe interface('eth0:1'), if: host_inventory['hostname'] == 'hostname3' do
      it { expect(subject).to exist }
      its(:ipv4_address) { is_expected.to match(%r{.*\.99/22$}) }
    end

    network_interfaces.each do |eth_interface, attributes|
      describe interface(eth_interface) do
        it { expect(subject).to exist }
        its(:ipv4_address) { is_expected.to match(attributes[:ipaddress]) }
      end

      describe file('/etc/sysconfig/network-scripts/ifcfg-' + eth_interface) do
        it { expect(subject).to be_file }
        its(:content) { is_expected.to match(attributes[:ipaddress_line]) }
        its(:content) { is_expected.to match(attributes[:netmask_line]) }
      end
    end

    ['one-db', 'two-db'].each do |the_host|
      describe host(the_host) do
        it { expect(subject).to be_reachable }
      end
    end
  end

  describe 'Processes are running.' do
    describe process('java'), if: host_inventory['hostname'] == 'hostname3' do
      it { expect(subject).to be_running }
      its(:user) { is_expected.to eq('appuser01') }
    end
  end

  describe 'Miscellaneous stuff.' do
    describe command('source /env_script; online -') do
      its(:stdout) { is_expected.to match(/onine|readonly/) }
    end
  end
end
