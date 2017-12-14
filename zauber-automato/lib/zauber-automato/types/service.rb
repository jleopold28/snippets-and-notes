# service type
class Service < TypeBase
  # TODO: will not work with multiple runlevels
  def enabled?(level = nil)
    HashDumper.insert_hash('service', @name, 'enabled' => true, 'level' => level)
  end

  def has_start_mode?(mode)
    HashDumper.insert_hash('service', @name, 'start_mode' => mode)
  end

  def running?(under = nil)
    HashDumper.insert_hash('service', @name, 'running' => true, 'provider' => under)
  end

  def monitored_by?(monitor, monitor_name = nil)
    HashDumper.insert_hash('service', @name, 'monitor' => monitor, 'monitor_name' => monitor_name)
  end
end

def service(*args)
  Service.new(args.first)
end
