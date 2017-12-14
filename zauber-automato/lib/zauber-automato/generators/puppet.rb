# generator for Puppet manifests
class Puppet
  # generate cron resources
  def self.cron(specdir, resources)
    resources.each do |name, attributes|
      # generate cron resource
      resource_string = "cron { '#{name}':\n  ensure => present,\n"
      resource_string += "  command => '#{name}',\n"
      resource_string += "  minute => '#{attributes['minute']}',\n"
      resource_string += "  hour => '#{attributes['hour']}',\n"
      resource_string += "  monthday => '#{attributes['daymonth']}',\n"
      resource_string += "  month => '#{attributes['month']}',\n"
      resource_string += "  weekday => '#{attributes['dayweek']}',\n"
      resource_string += "  user => #{attributes['user']},\n" if attributes.key?('user')
      resource_string += "}\n\n"

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate file resources
  def self.file(specdir, resources)
    resources.each do |name, attributes|
      # generate file resource
      if attributes.key?('mount')
        # TODO: attrs
        resource_string = "mount { '#{name}':\n  ensure => mounted,\n"
      elsif !attributes.key?('block_device')
        resource_string = "file { '#{name}':\n"
        if attributes.key?('file')
          resource_string += "  ensure => file,\n"
        elsif attributes.key?('directory')
          resource_string += "  ensure => directory,\n"
        elsif attributes.key?('symlink')
          resource_string += "  ensure => link,\n"
          resource_string += "  target => '#{attributes['target']}',\n" if attributes.key?('symlink')
        elsif attributes.key?('exist')
          resource_string += "  ensure => present,\n"
        end
        resource_string += "  mode => '#{attributes['mode']}',\n" if attributes.key?('mode')
        resource_string += "  owner => '#{attributes['owner']}',\n" if attributes.key?('owner')
        resource_string += "  group => '#{attributes['group']}',\n" if attributes.key?('group')
      end
      resource_string += "}\n\n" unless attributes.key?('block_device')
      # unsupported intrinsically: block_device

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate group resources
  def self.group(specdir, resources)
    resources.each do |name, attributes|
      # generate group resource
      resource_string = "group { '#{name}':\n"
      resource_string += "  ensure => present,\n" if attributes.key?('exist')
      resource_string += "  gid => #{attributes['gid']},\n" if attributes.key?('gid')
      resource_string += "}\n\n"

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate package install resources
  def self.package(specdir, resources)
    resources.each do |name, attributes|
      # generate package install resource
      resource_string = "package { '#{name}':\n"
      resource_string += attributes.key?('version') ? "  ensure => '#{attributes['version']}',\n" : "  ensure => installed,\n"
      resource_string += "  provider => #{attributes['provider']},\n" if attributes.key?('provider')
      resource_string += "}\n\n"

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate sevice resources
  def self.service(specdir, resources)
    resources.each do |name, attributes|
      # generate service resource
      resource_string = "service { '#{name}':\n"
      resource_string += "  ensure => running,\n" if attributes.key?('running')
      if attributes.key?('enabled')
        resource_string += "  enabled => true,\n"
      elsif attributes.key?('start_mode')
        resource_string += "  enabled => #{attributes['start_mode'].downcase},\n"
      end
      resource_string += "  provider => #{attributes['provider']},\n" if attributes.key?('provider')
      resource_string += "}\n\n"
      # unspported: level, monitor, monitor_name

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate user resources
  def self.user(specdir, resources)
    resources.each do |name, attributes|
      # generate user resource
      resource_string = "user { '#{name}':\n"
      resource_string += "  ensure => present,\n" if attributes.key?('exist')
      resource_string += "  groups => #{attributes['group']},\n" if attributes.key?('group')
      resource_string += "  gid => #{attributes['primary_group']},\n" if attributes.key?('primary_group')
      resource_string += "  uid => #{attributes['uid']},\n" if attributes.key?('uid')
      resource_string += "  home => '#{attributes['homedir']}',\n" if attributes.key?('homedir')
      resource_string += "  shell => '#{attributes['shell']}',\n" if attributes.key?('shell')
      resource_string += "}\n\n"

      resource_string += "ssh_authorized_key { '#{name}':\n  user => #{name},\n  type => 'ssh-rsa',\n  key  => '#{attributes['authkey']}',\n}\n\n" if attributes.key?('authkey')

      # write out resource to manifest
      File.open("#{specdir}.pp", 'a') { |file| file.write(resource_string) }
    end
  end
end
