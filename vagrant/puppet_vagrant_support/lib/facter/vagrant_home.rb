# determines vagrant home directory
Facter.add(:vagrant_home) do
  setcode { Dir.glob('/home/*') }
end
