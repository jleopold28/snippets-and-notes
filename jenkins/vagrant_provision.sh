# enable jenkins repo
cp /vagrant/jenkins.repo /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# install git, java, jenkins, ansible, and docker
dnf install -y git java-1.8.0-openjdk jenkins ansible docker
# add jenkins user to docker group
groupadd docker && usermod -aG docker jenkins
systemctl restart docker
# disable setup wizard
sed -ir 's/^JENKINS_JAVA_OPTIONS=.*/JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/' /etc/sysconfig/jenkins
# start jenkins so it populates home directory
systemctl start jenkins; sleep 10
# retrieve and push update center data
curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack
# install plugins ('docker-pipeline' is installed as a pipeline dep; workflow-aggregator is the actual name of pipeline)
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 install-plugin workflow-aggregator blueocean ansible
# restart jenkins with plugins and changed password
systemctl restart jenkins; sleep 10
echo 'Need to configure plugins from within Global Tool Configuration in the GUI!'
