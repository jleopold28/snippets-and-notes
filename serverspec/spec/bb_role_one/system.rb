require 'spec_helper'

describe "#{host_inventory['fqdn']}: System checks for bb_role_one." do
  describe 'Services are running.' do
    %w(serviceone servicetwo servicethree).each do |the_service|
      describe service(the_service) do
        it { expect(subject).to be_running }
      end
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

    describe command('/sbin/service daemon status'), if: host_inventory['fqdn'] =~ /.*\.st[0-35-8].*/ do
      its(:stdout) { is_expected.to match(/READY/) }
    end

    describe service('LDAP'), if: os[:release] == '4' do
      it { expect(subject).to be_running }
    end
  end

  describe 'Processes are running.' do
    describe process('slapd'), if: os[:release] > '4' do
      it { expect(subject).to be_running }
    end

    describe process('squid') do
      it { expect(subject).to be_running }
    end

    describe command('/check_squid') do
      its(:exit_status) { is_expected.to eql(0) }
    end

    describe command('/usr/sbin/lsof -i :775') do
      its(:stdout) { is_expected.to match(/daemon/) }
    end

    describe command('/usr/bin/lpstat -r') do
      its(:stdout) { is_expected.to match(/scheduler is running/) }
    end

    describe command('/ptcommon /ptk status') do
      its(:exit_status) { is_expected.to eql(0) }
    end
  end

  describe 'Files and directories are properly configured.' do
    describe file('/etc/dhcpd.conf'), if: host_inventory['fqdn'] =~ /.*\.st[0-35-8].*/ do
      it { expect(subject).to be_file }
      its(:content) { is_expected.to match(/fixed-address/) }
    end

    describe file('/etc/dhcpd.conf'), if: host_inventory['fqdn'] =~ /.*\.st[49].*/ do
      it { expect(subject).to be_file }
      its(:content) { is_expected.to match(/include.*dhcpd.conf/) }
    end

    ['/etc/samba/smb.conf', '/138_rl.pid', '/138_sv.pid', '/Replicator.pid'].each do |the_file|
      describe file(the_file) do
        it { expect(subject).to be_file }
      end
    end

    describe file('/dev/ttydg38') do
      it { expect(subject).to be_character_device }
    end
  end

  describe 'Networking is properly configured.' do
    network_interfaces = {
      'eth0'   => { ipaddress_line: /^IPADDR=.*\.5$/,
                    netmask_line:   /^NETMASK=5\.5\.2\.0$/,
                    ipaddress:      %r{.*\.5/23$} },
      'eth0:1' => { ipaddress_line: /^IPADDR=.*\.1$/,
                    netmask_line:   /^NETMASK=2\.5\.2\.0$/,
                    ipaddress:      %r{.*\.1/55$} },
      'eth0:2' => { ipaddress_line: /^IPADDR=.*\.4$/,
                    netmask_line:   /^NETMASK=5\.5\.2\.0$/,
                    ipaddress:      %r{.*\.4/55$} },
      'eth0:3' => { ipaddress_line: /^IPADDR=192\.168\.0\.35$/,
                    netmask_line:   /^NETMASK=5\.5\.5\.4$/,
                    ipaddress:      '192.168.0.35/55' },
      'lo'     => { ipaddress_line: /^IPADDR=127\.0\.0\.1$/,
                    netmask_line:   /^NETMASK=255\.0\.0\.0$/,
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
    ['/2 test', '/aak', '/aap.stat', '/LockManager -test'].each do |the_command|
      describe command(the_command) do
        its(:exit_status) { is_expected.to eql(0) }
      end
    end

    describe command('/usr/bin/lpstat -p') do
      its(:stdout) { is_expected.to match(/printer.*enabled/) }
    end
  end
end
