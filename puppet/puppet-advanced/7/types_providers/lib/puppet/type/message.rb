Puppet::Type.newtype(:message) do
  require 'puppet/parameter/boolean'

  @doc = "Creates a message to be output.

    Example:

    message { 'hello world': }
  "

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name) do
    desc 'The name of the message.'
    isnamevar
  end

  newparam(:output) do
    desc 'The output for the message.'
    defaultto { @resource[:name] }
  end

  newparam(:capitalize) do
    desc 'Capitalize the message.'
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:lowercase) do
    desc 'Lowercase the message.'
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:reverse) do
    desc 'Reverse the message.'
    newvalues(:true, :false)
    defaultto :false
  end
end
