# Custom facts for servers
require_relative 'facter_plugin'

# is this not a server? do nothing
if Facter.value(:hostname) =~ /^abcdefg[0-8]$/
  # instantiate the FacterPlugin object
  custom_facts = FacterPlugin.new

  # load in the custom facts
  Facter.add(:deploy_lang) { setcode { custom_facts.deploy_lang } }
  Facter.add(:env) { setcode { custom_facts.env } }
  Facter.add(:nation_code) { setcode { custom_facts.nation_code } }
  Facter.add(:other_environment) { setcode { custom_facts.other_environment } }
  Facter.add(:area) { setcode { custom_facts.area } }
  Facter.add(:region) { setcode { custom_facts.region } }
  Facter.add(:server_number) { setcode { custom_facts.server_number } }
  Facter.add(:role) { setcode { custom_facts.role } }
  Facter.add(:subnet) { setcode { custom_facts.subnet } }
  Facter.add(:rpms) { setcode { custom_facts.rpms } }
end
