require 'yaml'
require_relative '../spec_helper'

describe 'custom::special_install' do
  let(:title) { 'special_install test' }

  test_pkg_hash = YAML.load_file(File.expand_path('../../fixtures/hieradata/common.yaml', __FILE__))['test_pkg_hash']
  installed_hash = { 'ruby'   => '2.0.0',
                     'python' => '2.7.5',
                     'perl'   => '5.16',
                     'gcc'    => '4.8.3'
                   }

  context 'with test_pkg_hash => ruby, python, perl, gcc versioned' do
    let(:params) { { pkg_hash: test_pkg_hash } }
    let(:facts) { { rpms: installed_hash } }

    it { is_expected.to contain_custom__special_install('special_install test').with_pkg_hash(test_pkg_hash) }

    it { is_expected.to contain_package('ruby').with_ensure('installed') }
    it { is_expected.to contain_package('python').with_ensure('installed') }
    it { is_expected.to contain_package('python').that_requires('Package[ruby]') }
    it { is_expected.to contain_package('perl').with_ensure('5.18') }
    it { is_expected.to contain_package('perl').that_requires('Package[python]') }
    it { is_expected.to contain_package('gcc').with_ensure('4.8.8') }
    it { is_expected.to contain_package('gcc').that_requires('Package[perl]') }
  end
end
