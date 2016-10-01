require 'spec_helper'

describe 'custom::dataload' do
  let(:title) { 'dataload test' }

  context 'with dataload => 9999 FOOBAR N' do
    let(:params) { { dataload: '9999 FOOBAR N' } }

    it { is_expected.to contain_custom__dataload('dataload test').with_dataload('9999 FOOBAR N') }

    it { is_expected.to contain_exec("/bin/ksh -c 'source /env_script; /bin/dataload 9999 FOOBAR N'").with(
      'environment' => 'TMP=/private/tmp',
      'umask'       => '000',
      'unless'      => '/bin/grep "9999 FOOBAR N" /private/tmp/*'
    )
    }
    it { is_expected.to contain_exec("/bin/ksh -c 'source /env_script; /bin/dataload 9999 FOOBAR N'").that_notifies('Exec[/bin/chown user:group /private/tmp/*]') }

    it { is_expected.to contain_exec('/bin/chown user:group /private/tmp/*').with_refreshonly('true') }
  end
end
