# gordon_config custom matcher method
class GordonConfig < Inspec.resource(1)
  name 'gordon_config'

  desc '
    Resource description ...
  '

  example "
    describe gordon_config do
      its(:signal) { is_expected.to eq('on') }
    end
  "

  # Load the configuration file on initialization
  def initialize(path = nil)
    @path = path || '/etc/gordon.conf'
    @params = SimpleConfig.new(read_content)
  end

  # Expose all parameters of the configuration file
  def respond_to_missing?(name)
    @params[name] || super
  end
  # def method_missing(name)
  #   @params[name]
  # end

  private

  # grab content from the gordon config
  def read_content
    if inspec.file(@path).file?
      inspec.file(@path).content
    else
      skip_resource "Can't read config from #{@path}."
    end
  end
end
