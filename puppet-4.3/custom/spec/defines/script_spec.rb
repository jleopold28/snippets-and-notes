require 'spec_helper'

describe 'custom::script' do
  let(:title) { 'script test' }

  context 'with script => foo.ksh' do
    let(:params) { { script: 'foo.ksh', module: 'custom' } }

    it { is_expected.to contain_custom__script('script test').with(
      'module' => 'custom',
      'script' => 'foo.ksh'
    )
    }

    it { is_expected.to contain_file('/tmp/foo.ksh').with(
      'ensure' => 'file',
      'source' => 'puppet:///modules/custom/foo.ksh'
    )
    }
    it { is_expected.to contain_exec('/bin/ksh /tmp/foo.ksh').with_refreshonly('true') }
    it { is_expected.to contain_exec('/bin/ksh /tmp/foo.ksh').that_subscribes_to('File[/tmp/foo.ksh]') }
  end

  context 'with script => bar.ksh and extra file attributes' do
    let(:params) { { script: 'bar.ksh', module: 'custom', file_attr: { 'owner' => 'odin', 'mode' => '1777' } } }

    it { is_expected.to contain_custom__script('script test').with(
      'module'    => 'custom',
      'script'    => 'bar.ksh',
      'file_attr' => { 'owner' => 'odin', 'mode' => '1777' }
    )
    }

    it { is_expected.to contain_file('/tmp/bar.ksh').with(
      'ensure' => 'file',
      'source' => 'puppet:///modules/custom/bar.ksh',
      'owner'  => 'odin',
      'mode'   => '1777'
    )
    }
    it { is_expected.to contain_exec('/bin/ksh /tmp/bar.ksh').with_refreshonly('true') }
    it { is_expected.to contain_exec('/bin/ksh /tmp/bar.ksh').that_subscribes_to('File[/tmp/bar.ksh]') }
  end

  context 'with script => baz.ksh and extra exec attributes' do
    let(:params) { { script: 'baz.ksh', module: 'custom', exec_attr: { 'user' => 'thor', 'umask' => '000' } } }

    it { is_expected.to contain_custom__script('script test').with(
      'module'    => 'custom',
      'script'    => 'baz.ksh',
      'exec_attr' => { 'user' => 'thor', 'umask' => '000' }
    )
    }

    it { is_expected.to contain_file('/tmp/baz.ksh').with(
      'ensure' => 'file',
      'source' => 'puppet:///modules/custom/baz.ksh'
    )
    }
    it { is_expected.to contain_exec('/bin/ksh /tmp/baz.ksh').with(
      'refreshonly' => 'true',
      'user'        => 'thor',
      'umask'       => '000'
    )
    }
    it { is_expected.to contain_exec('/bin/ksh /tmp/baz.ksh').that_subscribes_to('File[/tmp/baz.ksh]') }
  end
end
