Facter.add(:java_version) do
  confine osfamily: /windows/i
  setcode do
    if Facter::Core::Execution.which('java')
      raw_version = Facter::Core::Execution.execute('java -version 2>&1')
      /(\d+\.\d+\.0_\d+)/.match(raw_version)[0]
    else
      '0.0'
    end
  end
end
