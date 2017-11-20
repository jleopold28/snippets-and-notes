require 'serverspec'

set :backend, :exec

if host_inventory['platform'] =~ /suse/
  describe file('/etc/sysctl.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.to match(/net\.ipv4\.conf/) }
    its(:content) { is_expected.not_to match(/kernel\.shmall/) }
  end
elsif host_inventory['platform'] =~ /debian/
  describe file('/etc/sysctl.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.not_to match(/net\.ipv4\.conf/) }
    its(:content) { is_expected.to match(/kernel\.shmall/) }
  end
end
