# generator for Ansible task lists
class Ansible
  # generate cron tasks
  def self.cron(specdir, resources)
    resources.each do |name, attributes|
      # generate cron task
      resource_string = "- name: cron entry #{name}\n  cron:\n"
      resource_string += "    job: #{name}\n"
      resource_string += "    minute: #{attributes['minute']}\n"
      resource_string += "    hour: #{attributes['hour']}\n"
      resource_string += "    day: #{attributes['daymonth']}\n"
      resource_string += "    month: #{attributes['month']}\n"
      resource_string += "    weekday: #{attributes['dayweek']}\n"
      resource_string += "    user: #{attributes['user']}\n" if attributes.key?('user')
      resource_string += "\n"

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate file tasks
  def self.file(specdir, resources)
    resources.each do |name, attributes|
      # generate file task
      if attributes.key?('mount')
        # TODO: attrs
        resource_string = "- name: mount #{name}\n"
        resource_string += "  mount:\n    name: #{name}\n"
        resource_string += "    state: mounted\n"
      elsif attributes.key?('block_device')
        resource_string = "- name: block_device #{name}\n"
        resource_string += "  filesystem:\n    dev: '#{name}'\n"
      else
        resource_string = "- name: file #{name}\n"
        resource_string += "  file:\n    path: '#{name}'\n"
        if attributes.key?('file')
          resource_string += "    state: touch\n"
        elsif attributes.key?('directory')
          resource_string += "    state: directory\n"
        elsif attributes.key?('symlink')
          resource_string += "    state: link\n"
          resource_string += "    src: '#{attributes['target']}'\n" if attributes.key?('target')
        elsif attributes.key?('exist')
          resource_string += "    state: file\n"
        end
        resource_string += "    mode: #{attributes['mode']}\n" if attributes.key?('mode')
        resource_string += "    owner: #{attributes['owner']}\n" if attributes.key?('owner')
        resource_string += "    group: #{attributes['group']}\n" if attributes.key?('group')
      end
      resource_string += "\n"

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate group tasks
  def self.group(specdir, resources)
    resources.each do |name, attributes|
      # generate group task
      resource_string = "- name: configure group #{name}\n"
      resource_string += "  group:\n    name: #{name}\n"
      resource_string += "    state: present\n" if attributes.key?('exist')
      resource_string += "    gid: #{attributes['gid']}\n" if attributes.key?('gid')
      resource_string += "\n"

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate package install tasks
  def self.package(specdir, resources)
    resources.each do |name, attributes|
      # generate poackage install task
      resource_string = "- name: install #{name}\n"
      resource_string += attributes.key?('provider') ? "  #{attributes['provider']}:\n" : "  package:\n"
      resource_string += attributes.key?('version') ? "    name: #{name}-#{attributes['version']}\n" : "    name: #{name}\n"
      resource_string += "    state: present\n\n"

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate service tasks
  def self.service(specdir, resources)
    # TODO: block generating a task for the start_mode only
    resources.each do |name, attributes|
      # generate service task
      resource_string = "- name: control service #{name}\n"
      resource_string += "  service:\n    name: #{name}\n"
      resource_string += "    state: started\n" if attributes.key?('running')
      resource_string += "    enabled: true\n" if attributes.key?('enabled')
      resource_string += "    runlevel: #{attributes['level']}\n" if attributes.key?('level')
      resource_string += "\n"
      # unsupported: provider, start_mode, monitor, monitor_name

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate user tasks
  def self.user(specdir, resources)
    resources.each do |name, attributes|
      # generate user task
      resource_string = "- name: configure user #{name}\n"
      resource_string += "  user:\n    name: #{name}\n"
      resource_string += "    state: present\n" if attributes.key?('exist')
      resource_string += "    groups: #{attributes['group']}\n" if attributes.key?('group')
      resource_string += "    group: #{attributes['primary_group']}\n" if attributes.key?('primary_group')
      resource_string += "    uid: #{attributes['uid']}\n" if attributes.key?('uid')
      resource_string += "    home: '#{attributes['homedir']}'\n" if attributes.key?('homedir')
      resource_string += "    shell: '#{attributes['shell']}'\n" if attributes.key?('shell')
      resource_string += "\n"

      resource_string += "- name: #{name} authorized key\n  authorized_key:\n    user: #{name}\n    key: '#{attributes['authkey']}'\n\n" if attributes.key?('authkey')

      # write out task to task list
      File.open("#{specdir}.yml", 'a') { |file| file.write(resource_string) }
    end
  end
end
