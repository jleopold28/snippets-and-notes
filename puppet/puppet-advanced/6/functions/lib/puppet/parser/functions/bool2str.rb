# convert boolean to string
module Puppet::Parser::Functions
  newfunction(:bool2str, type: rvalue, arity: 1) do |args|
    args[0].to_str
  end
end
