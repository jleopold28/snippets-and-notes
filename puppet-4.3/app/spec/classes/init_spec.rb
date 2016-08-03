require 'spec_helper'

describe 'app' do
  context 'when deployed on role_one' do
    let(:facts) { { role: 'role_one',
                    rpms: { 'puppet' => '4.5.0' }
                  }
    }

    it { is_expected.to contain_class('app') }
    # it { is_expected.to compile.with_all_deps }
  end
end
