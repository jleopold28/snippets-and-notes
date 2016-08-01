# TODO: convert cmdb.yaml to redis DB and change code here to access the redis DB values remotely on the master from the client; or use consul
require 'facter'
require 'yaml'

# facter plugin class from which custom facts can instantiate
class FacterPlugin
  attr_reader :cmdb_entry

  # initialize the object by loading in the cmdb.yaml and checking that it is valid
  def initialize(cmdb_file = '/var/opt/lib/pe-puppet/facts.d/cmdb.yaml')
    # abort if the cmdb.yaml did not arrive yet during pluginsync (pluginfacts occurs before plugin occurs before loading)
    abort "cmdb.yaml file was not transferred from puppetmaster to #{cmdb_file}." unless File.file?(cmdb_file)

    # load in user defined facts for this server
    begin
      @cmdb_entry = YAML.load_file(cmdb_file)[Facter.value(:domain)]
    rescue LoadError, SyntaxError
      abort 'The cmdb.yaml file has been corrupted.'
    end

    # parse user defined facts file and check for issues
    abort "#{Facter.value(:fqdn)} facts not present in the cmdb.yaml file." if @cmdb_entry.nil?
  end

  # default deploy language from cmdb
  def deploy_lang
    @cmdb_entry['deploy_lang'] =~ /^[a-z]{2}_[A-Z]{2}$/ ? @cmdb_entry['deploy_lang'] : (abort 'The deploy language entry for this server in the cmdb is malformed.')
  end

  # environment from domain or cmdb
  def env
    Facter.value(:domain) =~ /^svr([1-35-8][0-9]{3}|0[1-9][0-9]{2})\.domain$/ ? 'prod' : @cmdb_entry['env']
  end

  # two character nation code from domain or cmdb
  def nation_code
    nation_code = ''

    case Facter.value(:domain)
    when /^svr([1-358][0-9]{3}|0[1-9][0-9]{2})\.domain$/ then nation_code = 'us'
    when /^svr6[0-9]{3}\.domain$/ then nation_code = 'ca'
    else nation_code = @cmdb_entry['nation']
    end

    # TODO: en_ES breaks this
    abort 'Application default language and nation code are inconsistent.' unless (Facter.value(:deploy_lang) =~ /.*#{nation_code.upcase}$/) || Facter.value(:deploy_lang).nil?

    nation_code
  end

  # other environment from cmdb
  def other_environment
    @cmdb_entry['other_env'].nil? ? Facter.value(:env) : @cmdb_entry['other_env']
  end

  # area of server from cmdb
  def area
    @cmdb_entry['area'] =~ /^[0-9]{4}$/ ? @cmdb_entry['area'] : (abort 'Area number is malformed in cmdb.')
  end

  # region of server from cmdb
  def region
    @cmdb_entry['region'] =~ /^[0-9]{4}$/ ? @cmdb_entry['region'] : (abort 'Region number is malformed in cmdb.')
  end

  # server number from domain
  def server_number
    Facter.value(:domain).to_s =~ /^svr[0-9]{4}\.domain$/ ? /^svr([0-9]{4})\.domain$/.match(Facter.value(:domain).to_s).captures[0] : (abort 'Server number does not fit standard server nomenclature.')
  end

  # role from hostname and possibly nation code
  def role
    case Facter.value(:hostname)
    when 'abcdefg1', 'abcdfg5' then "#{Facter.value(:nation_code)}_role_one"
    when 'abcdfg2', 'abcdfg6' then 'role_two'
    when 'abcdfg3', 'abcdfg4', 'abcdfg7', 'abcdfg8' then 'role_three'
    else abort 'Hostname does not fit standard server nomenclature.'
    end
  end

  # subnet from ipv4 address
  def subnet
    Facter.value(:ipaddress).to_s =~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ ? /([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+/.match(Facter.value(:ipaddress).to_s).captures[0] : (abort 'Something is wrong with the server ipv4 address.')
  end

  # rpms installed and their versions
  def rpms
    rpms = `/bin/rpm -qa --qf "%{NAME}\n%{VERSION}-%{RELEASE}\n"`
    Hash[*rpms.split("\n")]
  end
end
