control 'sshd-11' do
  impact 1.0
  title 'Server: Set protocol version to SSHv2'
  desc 'Set the SSH protocol version to 2. Don\'t use legacy
        insecure SSHv1 connections anymore.'
  tag security: 'level-1'
  tag 'openssh-server'
  ref 'Server Security Guide v1.0', url: 'http://...'

  describe sshd_config do
    its(:protocol) { is_expected.to eq('2') }
  end
end
