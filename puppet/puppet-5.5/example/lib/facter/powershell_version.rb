Facter.add(:powershell_version) do
  confine osfamily: /windows/i
  setcode do
    begin
      raw_version = Facter::Core::Execution.execute('powershell -command $PSVersionTable.PSVersion.ToString()')
      /(\d+\.\d+\.\d+)/.match(raw_version)[0]
    rescue Facter::Core::Execution::ExecutionFailure
      '0.0'
    end
  end
end
