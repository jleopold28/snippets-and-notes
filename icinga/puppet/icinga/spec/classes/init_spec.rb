require 'spec_helper'

describe 'icinga' do
  context 'when deployed on a master' do
    let(:params) { { master: true } }

    it { is_expected.to contain_class('icinga') }
    it { is_expected.to compile.with_all_deps }
  end

  context 'when deployed on a centos client' do
    let(:params) { { master: false } }
    let(:facts) { { os: { 'name' => 'centos' },
                    fqdn: 'localhost.localdomain' }
    }

    it { is_expected.to contain_class('icinga') }
    it { is_expected.to compile.with_all_deps }
  end
end
