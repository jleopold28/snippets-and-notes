require 'serverspec'

set :backend, :exec

if host_inventory['hostname'] =~ /^sea/
  describe file('/etc/resolv.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.to match(/8\.8\.8\.8/) }
    its(:content) { is_expected.to match(/208\.67\.222\.222/) }
  end
else
  describe file('/etc/resolv.conf') do
    it { expect(subject).to be_file }
    its(:content) { is_expected.to match(/8\.8\.8\.8/) }
    its(:content) { is_expected.not_to match(/208\.67\.222\.222/) }
  end
end
