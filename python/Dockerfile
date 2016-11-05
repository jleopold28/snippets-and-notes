# usage: docker build .
# automatically prepares a dev/test env for service application and then executes tests

FROM centos:6
expose 8432

RUN /bin/mkdir service-application
RUN /bin/rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN /usr/bin/yum install python python-devel python-pip gcc libffi-devel openssl-devel -y
RUN /usr/bin/pip install --no-cache-dir --upgrade pip==7.1.2
RUN /usr/bin/pip install --no-cache-dir cffi cryptography ipaddress ndg-httpsclient pyOpenSSL requests[security] PyYAML argparse mock behave unittest2
COPY . /service-application
WORKDIR /service-application
RUN /usr/bin/pip install -e .
ENTRYPOINT ["/usr/bin/behave"]

# cleanup (when totally finished): docker rm $(docker ps -a -q); docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
