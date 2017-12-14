RSpec::Matchers.define :be_mounted do
  match do |path|
    path.mounted?(@attr)
  end

  # TODO: not working
  description do
    message = 'be mounted'
    message += " with attributes #{@attr}" if @pattr
    message
  end

  chain :with do |attr|
    @attr      = attr
  end

  chain :only_with do |attr|
    @attr      = attr
  end
end
