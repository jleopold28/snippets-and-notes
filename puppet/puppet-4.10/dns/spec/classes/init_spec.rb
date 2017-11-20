require 'spec_helper'

describe 'dns' do
  context 'when configuring a seattle server' do
    let(:facts) { { location: 'seattle' } }

    it { is_expected.to contain_class('dns') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/resolv.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /nameserver 208.67.222.222\nnameserver 208.67.220.220\nnameserver 8.8.8.8\nnameserver 8.8.4.4/
    )
    }
  end

  context 'when configuring a glasgow server' do
    let(:facts) { { location: 'glasgow' } }

    it { is_expected.to contain_class('dns') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/resolv.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /nameserver 8.8.8.8\nnameserver 8.8.4.4/
    )
    }
  end

  context 'when configuring an atlanta server' do
    let(:facts) { { location: 'atlanta' } }

    it { is_expected.to contain_class('dns') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/resolv.conf').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => /nameserver 8.8.8.8\nnameserver 8.8.4.4/
    )
    }
  end
end
