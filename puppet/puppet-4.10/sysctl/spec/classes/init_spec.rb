require 'spec_helper'

describe 'sysctl' do
  context 'when configuring a Debian server' do
    let(:facts) { { os: { name: 'Debian' } } }

    it { is_expected.to contain_class('sysctl') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/sysctl.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /kernel\.shmall/
    )
    }
  end

  context 'when configuring an OpenSUSE server' do
    let(:facts) { { os: { name: 'OpenSUSE' } } }

    it { is_expected.to contain_class('sysctl') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/sysctl.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /net\.ipv4\.conf\.all/
    )
    }
  end
end
