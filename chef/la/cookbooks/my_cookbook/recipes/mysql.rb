['mysql-server', 'mysql'].each do |db_package|
  package db_package do
    action :install
  end
end
