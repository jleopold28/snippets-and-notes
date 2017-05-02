file '/etc/motd' do
  content "Hostname is this: #{node['hostname']}"
end

# alternatively
template '/etc/motd' do
  source 'motd.erb'
  mode '0644'
end
