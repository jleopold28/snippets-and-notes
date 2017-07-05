# count the characters in a node name
module Puppet::Parser::Functions
  newfunction(:node_length, type: rvalue, arity: 0) do
    lookupvar('fqdn').length
  end
end
