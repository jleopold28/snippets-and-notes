require 'spec_helper'

describe 'pe_backup' do
  context 'when using puppet configured backups (default)' do
    it { is_expected.to contain_class('pe_backup') }
    it { is_expected.to contain_class('pe_backup::puppet') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/tmp/pe_backup/confdir').with(
      'ensure'  => 'directory',
      'source'  => 'file:////etc/puppetlabs/puppet',
      'recurse' => true
    )
    }

    it { is_expected.to contain_exec('/opt/puppetlabs/server/bin/pg_dump -Fc pe-activity -f /tmp/pg_backup/pe-activity.bin').with(
      'user'    => 'pe-postgres',
      'creates' => '/tmp/pg_backup/pe-activity.bin'
    )
    }
  end

  context 'when using script configured backups' do
    let(:params) { { scripts: true } }

    it { is_expected.to contain_class('pe_backup') }
    it { is_expected.to contain_class('pe_backup::scripts') }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/puppetlabs/puppetserver/pe_backup.sh') }
    it { is_expected.to contain_cron('pe_backup') }
  end
end
