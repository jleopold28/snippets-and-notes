require 'spec_helper'

describe 'profile::theapp' do
  context 'using default parameters on rhel7' do
    let(:facts) { { operatingsystem: 'RedHat' ,
                    osfamily: 'RedHat',
                    operatingsystemrelease: '7.4',
                    kernel: 'Linux',
                    augeasversion: '1.1',
                    puppetversion: '4.10' } }

    it { is_expected.to contain_class('profile::theapp') }
    it { is_expected.to compile.with_all_deps }
  end

  context 'using default parameters on ubuntu14' do
    let(:facts) { { operatingsystem: 'Ubuntu' ,
                    osfamily: 'Debian',
                    operatingsystemrelease: '14.04',
                    lsbdistcodename: 'trusty',
                    kernel: 'Linux',
                    augeasversion: '1.1',
                    puppetversion: '4.10' } }

    it { is_expected.to contain_class('profile::theapp') }
    it { is_expected.to compile.with_all_deps }
  end
end
