password = attribute('password', default: 'HARDCODEDpasswordHERE', description: 'password for admin user in mysql database')
db = mysql_session('admin', password)

describe db.query("SHOW DATABASES LIKE 'mydatabase'") do
  context "'mydatabase' database exists" do
    its(:stdout) { is_expected.to include('mydatabase') }
  end
end

describe db.query('SELECT User, Host FROM mysql.user') do
  its(:stdout) { is_expected.to include('admin %') }
  its(:stdout) { is_expected.to include('admin localhost') }
  its(:stdout) { is_expected.to include('user  %') }
  its(:stdout) { is_expected.to include('user  localhost') }
end
