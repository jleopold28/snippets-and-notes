require 'spec_helper'

describe 'custom::ldap' do
  let(:title) { 'ldap test' }

  context 'with ldap_conf => barbaz and module => custom' do
    let(:params) { { ldap_conf: 'barbaz', module: 'custom' } }

    it { is_expected.to contain_custom__ldap('ldap test').with(
      'module'    => 'custom',
      'ldap_conf' => 'barbaz'
    )
    }

    it { is_expected.to contain_file('/tmp/barbaz.ldap_conf').with(
      'ensure'  => 'file',
      'content' => '',
      'mode'    => '0777'
    )
    }

    it { is_expected.to contain_exec('/path/to/java LDAPModify -h localhost -D "cn=CN" -w `cat /ldap/.password` -a -c -f /tmp/barbaz.ldap_conf').with(
      'environment' => 'CLASSPATH=/path/to/ldapjdk.jar:/path/to/ldapfilt.jar',
      'refreshonly' => 'true'
    )
    }
    it { is_expected.to contain_exec('/path/to/java LDAPModify -h localhost -D "cn=CN" -w `cat /ldap/.password` -a -c -f /tmp/barbaz.ldap_conf').that_subscribes_to('File[/tmp/barbaz.ldap_conf]') }
    it { is_expected.to contain_exec('/path/to/java LDAPModify -h localhost -D "cn=CN" -w `cat /ldap/.password` -a -c -f /tmp/barbaz.ldap_conf').that_notifies('Exec[custom aaa]') }

    it { is_expected.to contain_exec('custom aaa').with(
      'command'     => '/bin/ksh /bin/aaa',
      'refreshonly' => 'true'
    )
    }
  end
end
