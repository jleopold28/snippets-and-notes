require 'inspec/resource'

# Logger resource
class Logger < Inspec.resource(1)
  name 'Logger'
  desc 'Check the logged output on a system and its attributes.'

  example "
    describe logger('row') do
      it { expect(subject).to be on }
      its(:version) { is_expected.to eq('1.2.3') }
      its(:type) { is_expected.to eq('foo') }
    end
  "

  def initialize(row)
    @name = row
    # making provider a Proc would make testing difficult so keeping this at two lines
    output = provider
    @info = parser(output.stdout)
  end

  # check the info for row on
  def on?
    @info[:status] == 'on'
  end

  # check the info for row version
  def version
    @info[:version]
  end

  # check the info for row type
  def type
    @info[:type]
  end

  def to_s
    "Logger Row #{@name}"
  end

  private

  # parser to format provider stdout into usable information for inspec checks
  def parser(stdout)
    # search for the row in the stdout (returns array)
    row = stdout.lines.grep(/#{@name}/)

    # return nil if no entry for the requested row name was in the stdout
    return nil if row.empty?

    # first column is the version
    version = row.first.split.first
    # grab the on or disabled from the line of output
    status = row.first.match(/(on|off)/)[0]
    # last column is the type
    type = row.first.split.last

    # return hash with row information
    { version: version, status: status, type: type }
  end

  # backend provider to grab logger info
  def provider
    # grab all the logger info
    cmd = inspec.command('logger --all')

    # return output object from logger command if success and nil if failed
    cmd.exit_status.to_i.zero? ? cmd : nil
  end
end
