file '/etc/motd' do
  content "Hostname is this: #{node['hostname']}"
end
