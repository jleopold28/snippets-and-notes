require 'spec_helper'

describe "#{host_inventory['fqdn']}: System checks for all servers." do
  describe 'All mount points are rw, have free space, and have inodes less than 80%.' do
    host_inventory['filesystem'].each do |_, filesystem_attributes|
      describe file(filesystem_attributes['mount']) do
        it { expect(subject).to be_mounted.with(options: { rw: true }) }

        describe 'Percentage used is less than 90%.' do
          it { expect(filesystem_attributes['percent_used'].to_i).to be < 90 }
        end

        describe 'Should have inodes less than 80%.' do
          describe command('/bin/df -iP ' + filesystem_attributes['mount'] + ' | /usr/bin/tail -n1 | awk \'{print $5}\''), if: filesystem_attributes['mount'] !~ %r{^(/dev$|/dev/shm$|/sys/fs/cgroup$|/run/user/)} do
            its(:stdout) { is_expected.to match(/^([0-9]|[0-7][0-9])%/) }
          end
        end
      end
    end

    describe 'Check root dev is listed first in /etc/fstab' do
      describe command('/bin/egrep -v "(^#)|(^$)" /etc/fstab | /usr/bin/head -n 1') do
        its(:stdout) { is_expected.to match(%r{.*/dev/mapper/vg00-lv_root.*}) }
      end
    end
  end

  describe 'Services are running.' do
    %w(named xinetd ntpd crond atd sshd).each do |the_service|
      describe service(the_service) do
        it { expect(subject).to be_running }
      end
    end

    describe service('snmpd'), if: os[:release] == '4' do
      it { expect(subject).to be_running }
    end
  end

  describe 'Processes are running.' do
    describe 'Checking legacy agent' do
      describe command('/bin/ps -ef | grep [d]aemonbot | wc -l') do
        its(:stdout) { is_expected.to eql("2\n") }
      end
    end

    describe process('dmnd') do
      it { expect(subject).to be_running }
    end
  end

  describe 'Files and directories are properly configured.' do
    describe file('/etc/nsswitch.conf') do
      it { expect(subject).to be_file }
      its(:content) { is_expected.to match(/files/) }
      its(:content) { is_expected.to match(/nsp/) }
    end

    ['/etc/hosts', '/etc/montab'].each do |the_file|
      describe file(the_file) do
        it { expect(subject).to be_file }
      end
    end

    describe file('/etc/ntp.conf') do
      it { expect(subject).to be_file }
      its(:content) { is_expected.to match(/server ntp1.domain/) }
      its(:content) { is_expected.to match(/server ntp2.domain/) }
      its(:content) { is_expected.to match(/server ntp3.domain/) }
    end

    describe command('/bin/ls /var/crash/vmware*') do
      its(:stderr) { is_expected.to match(/No such file or directory/) }
    end
  end

  describe 'Networking is properly configured.' do
    ['role_one', 'role_two', 'role_threea', "st#{ENV['SERVER_ID']}"].each do |the_host|
      describe host(the_host) do
        it { expect(subject).to be_reachable }
      end
    end

    describe 'Check DNS settings' do
      describe host_inventory['fqdn'] do
        it { expect(subject).to match(ENV['TARGET_HOST'][0..7]) }
      end

      describe host(host_inventory['fqdn']) do
        it { expect(subject).to be_resolvable.by('dns') }
        it { expect(subject).to be_reachable }
        it { expect(subject).to be_reachable.with(port: 22) }
      end
    end
  end

  describe 'Miscellaneous stuff.' do
    describe command('/sbin/swapon -s') do
      its(:stdout) { is_expected.to match(/dev/) }
    end

    describe command('/sbin/runlevel') do
      its(:stdout) { is_expected.to eql("N 3\n") }
    end
  end
end
