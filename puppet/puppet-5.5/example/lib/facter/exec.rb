require 'facter'

Facter.add('exec') do
  confine kernel: 'Linux'
  setcode do
    if File.executable?('/opt/thing/bin/thing-status')
      Facter::Core::Execution.execute('/opt/thing/bin/thing-status') =~ /Here/ ? true : false
    else
      false
    end
  end
end
