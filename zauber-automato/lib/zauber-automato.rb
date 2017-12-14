# dependencies
require 'yaml'

# generators
require_relative 'zauber-automato/generators/ansible'
require_relative 'zauber-automato/generators/chef'
require_relative 'zauber-automato/generators/puppet'

# main class
class ZauberAutomato
  def initialize(specdir)
    # bail out if there were no resources gathered during rspec
    raise 'No valid resources gathered from spec files.' unless File.file?('tmp.yaml')

    # load in the resources from the yaml
    resources_hash = Psych.load_file('tmp.yaml')

    # clean up temporary yaml file which stored the resources from rspec
    File.delete('tmp.yaml')

    # iterate through resource types and pass off to generators
    %w(cron file group package service user).each do |type|
      # no resources of this type? skip to the next type
      next unless resources_hash.key?(type)

      # invoke generators on this type's resources
      Ansible.public_send(type.to_sym, specdir, resources_hash[type])
      Chef.public_send(type.to_sym, specdir, resources_hash[type])
      Puppet.public_send(type.to_sym, specdir, resources_hash[type])
    end
  end
end

# TODO: matchers can be negative
