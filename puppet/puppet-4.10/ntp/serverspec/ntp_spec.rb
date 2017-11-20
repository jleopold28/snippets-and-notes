require 'serverspec'

set :backend, :exec

if host_inventory['hostname'] =~ /^glas/
  describe file('/etc/ntp.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.to match(/uk\.pool\.ntp\.org/) }
  end
else
  describe file('/etc/ntp.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.to match(/us\.pool\.ntp\.org/) }
  end
end
