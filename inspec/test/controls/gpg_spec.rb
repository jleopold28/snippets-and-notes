control 'cis-1-2-1' do
  impact 1.0
  title '1.2.1 Verify CentOS GPG Key is Installed (Scored)'
  desc 'CentOS cryptographically signs updates with a GPG key to verify that they are valid.'
  describe command('/bin/rpm -q --queryformat "%{SUMMARY}\n" gpg-pubkey') do
    its(:stdout) { is_expected.to match(/Centos 6 Official Signing Key/) }
  end
end

control 'cis-1-2-2' do
  impact 1.0
  title '1.2.2 Verify that gpgcheck is Globally Activated (Scored)'
  desc 'The gpgcheck option, found in the main section of the /etc/yum.conf file determines if an RPM package\'s signature is always checked prior to its installation.'
  describe file('/etc/yum.conf') do
    its(:content) { is_expected.to match(/gpgcheck\s?=\s?1$/) }
  end
end
