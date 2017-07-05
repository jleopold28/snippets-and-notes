# output file contents
module Puppet::Parser::Functions
  newfunction(:file_output, type: rvalue, arity: 1) do |args|
    File.read(args[0])
  end
end
