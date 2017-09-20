# Vagrant version checking
raise 'Vagrant requires Cygwin or bash if on Windows.' if RUBY_PLATFORM =~ /mswin|msys|mingw|bccwin|wince|em[xc]/

Vagrant.require_version '>= 1.7.4'

case Vagrant::VERSION
when '1.9.4'
  raise '1.9.4 is incompatible with Windows.' if Vagrant::Util::Platform.windows?
when '1.9.1'
  warn '1.9.1 has potential issues with Redhat networking.'
when '1.9.0'
  warn '1.9.0 will error on plugin checks. You will need to manually install plugins and remove the relevant code for checking them from the Vagrantfile.'
when '1.8.7'
  raise '1.8.7 is incompatible with MacOSX.' if RUBY_PLATFORM =~ /darwin/
when '1.8.6'
  warn '1.8.6 has potential issues with Linux networking.'
when '1.8.5'
  raise '1.8.5 is broken.'
end

# install specified plugins
def plugins_install(plugins)
  installed = false
  sudo = RUBY_PLATFORM =~ /cygwin/ ? '' : 'sudo'

  plugins.each do |plugin|
    next if Vagrant.has_plugin?(plugin)
    system "#{sudo} vagrant plugin install #{plugin}"
    puts "Rerun vagrant command to recognize installed plugin #{plugin}."
    installed = true
  end

  exit 0 if installed
end
