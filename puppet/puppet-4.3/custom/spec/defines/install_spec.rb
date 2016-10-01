require 'spec_helper'
require 'yaml'

describe 'custom::install' do
  let(:title) { 'install test' }

  test_pkg_hash = YAML.load_file(File.expand_path('../../fixtures/hieradata/common.yaml', __FILE__))['test_pkg_hash']

  context 'with test_pkg_hash => ruby, python, perl, gcc versioned' do
    let(:params) { { pkg_hash: test_pkg_hash } }

    it { is_expected.to contain_custom__install('install test').with_pkg_hash(test_pkg_hash) }

    it { is_expected.to contain_package('ruby').with_ensure('1.9.3') }
    it { is_expected.to contain_package('python').with_ensure('2.7.5') }
    it { is_expected.to contain_package('python').that_requires('Package[ruby]') }
    it { is_expected.to contain_package('perl').with_ensure('5.18') }
    it { is_expected.to contain_package('perl').that_requires('Package[python]') }
    it { is_expected.to contain_package('gcc').with_ensure('4.8.8') }
    it { is_expected.to contain_package('gcc').that_requires('Package[perl]') }
  end
end
