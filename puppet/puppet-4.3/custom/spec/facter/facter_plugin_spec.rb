# TODO: work on hacking around to finish these tests (use facter stubs for rspec? check peter huene email)
require_relative '../../lib/facter/facter_plugin.rb'

# TODO: change describe to describe FacterPlugin?
describe 'The cmdb.yaml is loading correctly' do
  context 'with default cmdb.yaml that actually does not exist' do
    it { expect { FacterPlugin.new }.to raise_error('cmdb.yaml file was not transferred from puppetmaster to /var/opt/lib/pe-puppet/facts.d/cmdb.yaml.') }
    it { expect { FacterPlugin.new }.to raise_error(SystemExit) }
  end

  context 'with alternate cmdb.yaml that actually does exist' do
    let(:cmdb_load) { FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/faux_cmdb.yaml') }

    it { expect(cmdb_load.cmdb_entry).to be_a_kind_of(Hash) }
    it { expect(cmdb_load.cmdb_entry).to include('deploy_lang') }
  end

  context 'with alternate cmdb.yaml that is missing the host entry' do
    it { expect { FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/host_missing.yaml') }.to raise_error("#{Facter.value(:fqdn)} facts not present in the cmdb.yaml file.") }
    it { expect { FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/host_missing.yaml') }.to raise_error(SystemExit) }
  end

  context 'with malformed values for deploy_lang, region, and area' do
    let(:cmdb_load) { FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/bad_entries.yaml') }

    it { expect { cmdb_load.deploy_lang }.to raise_error('The deploy language entry for this server in the cmdb is malformed.') }
    it { expect { cmdb_load.deploy_lang }.to raise_error(SystemExit) }

    it { expect { cmdb_load.area }.to raise_error('Area number is malformed in cmdb.') }
    it { expect { cmdb_load.area }.to raise_error(SystemExit) }

    it { expect { cmdb_load.region }.to raise_error('Buying office number is malformed in cmdb.') }
    it { expect { cmdb_load.region }.to raise_error(SystemExit) }
  end
end

describe 'The custom facts are loaded correctly' do
  context 'for any server' do
    let(:python_version) { `/bin/rpm -q python --qf %{VERSION}-%{RELEASE}` }

    it { expect(FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/faux_cmdb.yaml').rpms).to include('python' => python_version) }
  end

  context 'with a fqdn that does not fit any regexp' do
    let(:cmdb_load) { FacterPlugin.new(File.dirname(__FILE__) + '/../fixtures/facter/faux_cmdb.yaml') }

    it { expect(cmdb_load.default_lang).to eql('en_US') }
    it { expect(cmdb_load.env).to eql('prod') }
    it { expect(cmdb_load.nation_code).to eql('bb') }
    it { expect(cmdb_load.other_environment).to eql('qa') }
    it { expect(cmdb_load.area).to eql('atlantis') }
    it { expect(cmdb_load.region).to eql('atlantis') }
    # subnet returns correct regexp from ipaddress

    # why is this not working as expected
    it { expect(cmdb_load.server_number).to raise_error('Server number does not fit standard server nomenclature.') }
    it { expect(cmdb_load.server_number).to raise_error(SystemExit) }
  end

  context 'with a prod bb role_one server' do
    # nation_code is bb for specific domains
    # env is prod for specific domains
    # role is role_one
    # server_number returns correct regexp from domain
  end

  context 'with a prod aa role_one server' do
    # nation_code is aa for other domains
    # env is prod for specific domains
    # role is role_one
    # other_environment returns env if host entry nil
  end

  context 'with a qa role_two server and a french deploy language' do
    # role is role_two
    # aborts if deploy_lang and nation_code do not match
  end

  context 'with a qa aa role_three server that has a messed up ipaddress' do
    # role is role_three
    # aborts if subnet does not fit regexp
  end

  context 'with a domain that has a proper server number but an improper hostname' do
    # aborts if hostname does not fit anything
  end
end
