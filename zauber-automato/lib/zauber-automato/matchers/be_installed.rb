# be_installed matcher
RSpec::Matchers.define :be_installed do
  match do |subject|
    subject.installed?(@provider, @version)
  end

  description do
    message = 'be installed'
    message += " with provider #{@provider}" if @provider
    message += " with version #{@version}" if @version
    message
  end

  chain :by do |provider|
    @provider = provider
  end

  chain :with_version do |version|
    @version = version
  end
end
