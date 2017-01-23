module Puppet::Parser::Functions
  newfunction(:conjur_fetch, type: :rvalue) do |args|
    `/usr/local/bin/conjur variable value #{args[0]}/#{args[1]}`
  end
end
