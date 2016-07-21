require 'spec_helper'

describe "#{host_inventory['fqdn']}: System checks for role_two." do
  describe 'Services are running.' do
    describe command('/sbin/service httpd_server') do
      its(:stderr) { is_expected.to match(/unrecognized service/) }
    end
  end

  describe 'Networking is properly configured.' do
    network_interfaces = {
      'eth0'   => { ipaddress_line: /^IPADDR=.*\.11$/,
                    netmask_line:   /^NETMASK=2\.2\.2\.0$/,
                    ipaddress:      %r{.*\.11/22$} },
      'eth0:2' => { ipaddress_line: /^IPADDR=.*\.22$/,
                    netmask_line:   /^NETMASK=3\.3\.3\.0$/,
                    ipaddress:      %r{.*\.22/22$} },
      'eth0:3' => { ipaddress_line: /^IPADDR=44\.44\.44\.44$/,
                    netmask_line:   /^NETMASK=5\.5\.5\.2$/,
                    ipaddress:      '192.168.0.2/55' },
      'eth0:4' => { ipaddress_line: /^IPADDR=55\.55\.55\.1$/,
                    netmask_line:   /^NETMASK=6\.6\.6\.6$/,
                    ipaddress:      '192.168.0.3/55' },
      'lo'     => { ipaddress_line: /^IPADDR=66\.66\.66\.1$/,
                    netmask_line:   /^NETMASK=77\.0\.0\.0$/,
                    ipaddress:      '127.0.0.1/55' }
    }
    describe interface('eth0') do
      it { expect(subject).to be_up }
    end

    network_interfaces.each do |eth_interface, attributes|
      describe interface(eth_interface) do
        it { expect(subject).to exist }
        its(:ipv4_address) { is_expected.to match(attributes[:ipaddress]) }
      end

      describe file('/etc/sysconfig/network/ifcfg-' + eth_interface) do
        it { expect(subject).to be_file }
        its(:content) { is_expected.to match(attributes[:ipaddress_line]) }
        its(:content) { is_expected.to match(attributes[:netmask_line]) }
      end
    end

    ['one-db', 'two-db', 'three-db'].each do |the_host|
      describe host(the_host) do
        it { expect(subject).to be_reachable }
      end
    end
  end

  describe 'Miscellaneous stuff.' do
    describe command('source /env_script; online -') do
      its(:stdout) { is_expected.to match(/online|readonly/) }
    end
  end
end
