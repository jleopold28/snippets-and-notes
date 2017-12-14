# generator for Chef recipes
class Chef
  # generate cron resources
  def self.cron(specdir, resources)
    resources.each do |name, attributes|
      # generate cron resource
      resource_string = "cron '#{name}' do\n  action :create\n"
      resource_string += "  command: '#{name}'\n"
      resource_string += "  minute: '#{attributes['minute']}'\n"
      resource_string += "  hour: '#{attributes['hour']}'\n"
      resource_string += "  day: '#{attributes['daymonth']}'\n"
      resource_string += "  month: '#{attributes['month']}'\n"
      resource_string += "  weekday: '#{attributes['dayweek']}'\n"
      resource_string += "  user '#{attributes['user']}'\n" if attributes.key?('user')
      resource_string += "end\n\n"

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate file resources
  def self.file(specdir, resources)
    resources.each do |name, attributes|
      # generate file resource
      if attributes.key?('mount')
        # TODO: attrs
        resource_string = "mount '#{name}' do\n  action :mount\n"
      elsif !attributes.key?('block_device')
        if attributes.key?('file')
          resource_string = "file '#{name}' do\n  action :create\n"
        elsif attributes.key?('directory')
          resource_string = "directory '#{name}' do\n  action :create\n"
        elsif attributes.key?('symlink')
          resource_string = "link '#{name}' do\n  action :create\n"
          resource_string += "  to '#{attributes['target']}'\n" if attributes.key?('symlink')
        elsif attributes.key?('exist')
          resource_string = "file '#{name}' do\n  action :create_if_missing\n"
        end
        resource_string += "  mode: '#{attributes['mode']}'\n" if attributes.key?('mode')
        resource_string += "  owner: '#{attributes['owner']}'\n" if attributes.key?('owner')
        resource_string += "  group: '#{attributes['group']}'\n" if attributes.key?('group')
      end
      resource_string += "end\n\n" unless attributes.key?('block_device')
      # unsupported intrinsically: block_device

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate group resources
  def self.group(specdir, resources)
    resources.each do |name, attributes|
      # generate group resource
      resource_string = "group '#{name}' do\n"
      resource_string += "  action :create\n" if attributes.key?('exist')
      resource_string += "  gid '#{attributes['gid']}'\n" if attributes.key?('gid')
      resource_string += "end\n\n"

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate package install resources
  def self.package(specdir, resources)
    resources.each do |name, attributes|
      # generate poackage install task
      resource_string = "package '#{name}' do\n  action :install\n"
      resource_string += "  version '#{attributes['version']}'\n" if attributes.key?('version')
      resource_string += "  provider Chef::Provider::Package::#{attributes['provider'].capitalize}\n" if attributes.key?('provider')
      resource_string += "end\n\n"

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate service resources
  def self.service(specdir, resources)
    resources.each do |name, attributes|
      # TODO: this needs a cleanup bad
      # generate service resource
      if attributes.key?('start_mode')
        resource_string = "windows_service '#{name}' do\n"
        resource_string += "  action :configure_startup\n"
        resource_string += "  startup_type :manual\n" if attributes.key?('start_mode')
        resource_string += "end\n\n"
        # if the serverspec resource is doing more than just specifying the startup_type, then begin constructing another chef resource to handle that
        resource_string += "service '#{name}' do\n" if attributes.length > 1
      else
        resource_string = "service '#{name}' do\n"
      end
      if attributes.key?('running') && attributes.key?('enabled')
        resource_string += "  action [:start, :enable]\n"
      elsif attributes.key?('running')
        resource_string += "  action :start\n"
      elsif attributes.key?('enabled')
        resource_string += "  action :enable\n"
      end
      resource_string += "  priority '#{attributes['level']}'\n" if attributes.key?('level')
      resource_string += "  provider Chef::Provider::Service::#{attributes['provider'].capitalize}\n" if attributes.key?('provider')
      resource_string += "end\n\n"
      # unsupported: monitor, monitor_name

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end

  # generate user resources
  def self.user(specdir, resources)
    resources.each do |name, attributes|
      # generate user resource
      resource_string = "user '#{name}' do\n"
      resource_string += "  action :create\n" if attributes.key?('exist')
      resource_string += "  gid '#{attributes['primary_group']}'\n" if attributes.key?('primary_group')
      resource_string += "  uid '#{attributes['uid']}'\n" if attributes.key?('uid')
      resource_string += "  home '#{attributes['homedir']}'\n" if attributes.key?('homedir')
      resource_string += "  shell '#{attributes['shell']}'\n" if attributes.key?('shell')
      resource_string += "end\n\n"
      # unsupported: groups
      # unsupported in intrinsic chef: authkey

      # write out resource to recipe
      File.open("#{specdir}.rb", 'a') { |file| file.write(resource_string) }
    end
  end
end
