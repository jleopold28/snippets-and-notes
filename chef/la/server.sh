# install chef packages
rpm -ivh https://packages.chef.io/files/stable/chefdk/1.3.40/el/7/chefdk-1.3.40-1.el7.x86_64.rpm
rpm -ivh https://packages.chef.io/files/stable/chef-server/12.14.0/el/7/chef-server-core-12.14.0-1.el7.x86_64.rpm
# install support packages
yum install docker -y
chef exec gem install kitchen-docker
chef-server-ctl install chef-manage
# configure knife
sudo -u vagrant 'mkdir .chef'
echo "log_level         :info
log_location            STDOUT
node_name               'server.local'
client_key              '/home/vagrant/.chef/server.pem'
cookbook_path           ['/home/vagrant/cookbooks']
validation_client_name  'chef-validator'
validation_key          '/home/vagrant/.ssh/chef.pem'
chef_server_url         'http://192.168.210.10'
syntax_check_cache_path '/home/vagrant/.chef/syntax_check_cache'" >> '.chef/knife.rb'
# reconfigure the server
chef-server-ctl reconfigure
# add admin user and org
chef-server-ctl user-create vagrant me too vagrant@localhost.com 'vagrant' --filename /home/vagrant/.ssh/chef.pem
chef-server-ctl org-create sealand 'Sealand' --association_user vagrant --filename /home/vagrant/.ssh/chef-org.pem
chef-manage-ctl reconfigure
# bootstrap client
knife bootstrap 192.168.210.11 -x vagrant -P vagrant --sudo
knife client show client.local
