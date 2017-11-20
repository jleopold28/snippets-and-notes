require 'spec_helper'

describe 'ntp' do
  context 'when configuring a seattle server' do
    let(:facts) { { location: 'seattle' } }

    it { is_expected.to contain_class('ntp') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/ntp.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /us\.pool\.ntp\.org/
    )
    }
  end

  context 'when configuring a glasgow server' do
    let(:facts) { { location: 'glasgow' } }

    it { is_expected.to contain_class('ntp') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/ntp.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /uk\.pool\.ntp\.org/
    )
    }
  end

  context 'when configuring an atlanta server' do
    let(:facts) { { location: 'atlanta' } }

    it { is_expected.to contain_class('ntp') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/ntp.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /us\.pool\.ntp\.org/
    )
    }
  end
end
