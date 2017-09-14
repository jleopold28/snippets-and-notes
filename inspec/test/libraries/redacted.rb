# redacted command
class Redacted < Inspec.resource(1)
  name 'redacted'
  desc 'Use the command resource to test an arbitrary command and redact the specified command in the output.'

  example "
    describe redacted('ls -al /') do
      its(:stdout) { is_expected.to match(/usr/) }
      its(:stderr) { is_expected.to eq('') }
      its(:exit_status) { is_expected.to eq(0) }
    end
  "

  def initialize(cmd = nil)
    @name = cmd
  end

  def result
    inspec.backend.run_command(@name)
  end

  def stdout
    result.stdout
  end

  def stderr
    result.stderr
  end

  def exit_status
    result.exit_status.to_i
  end

  def to_s
    'REDACTED'
  end
end
