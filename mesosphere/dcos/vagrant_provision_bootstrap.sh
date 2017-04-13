yum install docker -y
systemctl start docker
mkdir /vagrant/genconf
mv /vagrant/config.yaml /vagrant/genconf/config.yaml
