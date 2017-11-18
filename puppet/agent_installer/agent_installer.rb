#!/opt/puppetlabs/puppet/bin/ruby
# these all come with PE
require 'yaml'
require 'net/ssh'
# could replace curls with this given auth.conf modification and net/ssh enhancements
# require 'net/http'

# load in data
data = YAML.load_file('data.yaml')

# iterate over each host
data[:hosts].each do |host, host_data|
  # ssh into host
  Net::SSH.start(host, host_data[:user], keys: [data[:key]]) do |ssh|
    # open the channel so we can pseudo tty for sudo
    open_channel = ssh.open_channel do |channel|
      # pseudo tty
      channel.request_pty
      # create exec block to gather stdout and stderr
      channel.exec("/usr/bin/curl -k https://#{data[:master]}:8140/packages/current/install.bash | sudo /bin/bash") do |exec|
        exec.on_data { |_, stdout| $stdout.print stdout }
        exec.on_extended_data { |_, _, stderr| $stderr.print stderr }
        # ensure exec finishes
        exec.on_close { puts "Puppet Agent installation and configuration complete for #{host}." }
      end
      # wait for channel to finish
      channel.wait
    end
    # wait for open channel to finish
    open_channel.wait
  end

  # if certname is present in data and therefore different than hostname, replace host var with that
  host = host_data[:certname] if host_data.key?(:certname)
  # CA v1 API sends back empty replies, so use raw command
  system("sudo /opt/puppetlabs/bin/puppet cert sign -y #{host}")
end
