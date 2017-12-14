RSpec::Matchers.define :be_monitored_by do |monitor|
  match do |service|
    service.monitored_by?(monitor, @monitor_name)
  end

  description do
    @monitor_name ? "be monitored by #{monitor} with name #{@monitor_name}" : "be monitored by #{monitor}"
  end

  chain :with_name do |name|
    @monitor_name = name
  end
end
