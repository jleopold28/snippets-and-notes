import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize('file', [
    ('/srv/tomcat/catalina/tomcat_hello/app.war'),
    ('/src/tomcat/catalina/tomcat_hello/hello.config')
])
def test_tomcat_file(host, file):
    tomcat_file = host.file(file)

    assert tomcat_file.is_file
    assert tomcat_file.user == 'tomcat'
    assert tomcat_file.group == 'tomcat'


def test_tomcat_hello(host):
    tomcat_hello = host.service('tomcat_hello')

    assert tomcat_hello.is_running


def test_tomcat(host):
    tomcat = host.package('tomcat')

    assert tomcat.is_installed


def test_tomcat_user(host):
    tomcat_user = host.user('tomcat')

    # only way to test existence
    assert tomcat_user.name == 'tomcat'
