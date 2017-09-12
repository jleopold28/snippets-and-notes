require 'inspec/resource'

# CMD Arg resource
class CMDArg < Inspec.resource(1)
  name 'cmd_arg'
  desc 'Check a command using an arbitrary argument.'

  example "
    describe cmd_arg('python', '--version') do
      it { is_expected.to exist }
      its(:arg) { should eq('1.2.3') }
    end
  "

  def initialize(cmd = nil, arg = nil)
    @cmd = cmd
    @arg = arg
  end

  # check if it exists
  def exists?
    File.executable?(@cmd)
  end

  # get the argument value using the binary's cli
  def arg
    output = provider
    return nil if output.nil?
    # return parsed stdout or stderr depending upon which is being used
    raw_output = output.stdout.empty? ? output.stderr : output.stdout
    # parse raw output and return only the regexp
    raw_output.lines.first.chomp.match(/(\d\..*\d)/)[0].strip
  end

  def to_s
    "CMD Arg #{@cmd} #{@arg}"
  end

  private

  # backend provider to grab raw information output
  def provider
    # grab info
    cmd = inspec.command("#{@cmd} #{@arg}")
    # if something is wrong return nil; otherwise, return the inspec command output
    cmd.exit_status.to_i.zero? ? cmd : nil
  end
end
