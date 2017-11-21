require 'serverspec'

set :backend, :exec

%w[/var/opt/pe_backups /tmp/pe_backup /tmp/pg_backup].each do |backup_dir|
  describe file(backup_dir) do
    it { expect(subject).to be_directory }
  end
end
