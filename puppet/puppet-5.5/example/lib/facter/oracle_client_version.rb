Facter.add(:app_version) do
  confine osfamily: /windows/i
  setcode do
    version = '0.0'
    if File.directory?('C:\app\product')
      Dir.entries('C:\app\product').each do |dir|
        version += /(\d+\.\d+\.\d+)/.match(dir)[0]
      end
    end
    version
  end
end
