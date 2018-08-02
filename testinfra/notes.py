import pytest


def test_passwd_file(host):
    passwd = host.file('/etc/passwd')
    assert passwd.contains('root')
    assert passwd.user == 'root'
    assert passwd.group == 'root'
    assert passwd.mode == 0o644


def test_python_is_installed(host):
    python3 = host.package('python3')
    assert python3.is_installed
    assert python3.version.startswith('3.6')


def test_cron_running_and_enabled(host):
    cron = host.service('cron')
    assert cron.is_running
    assert cron.is_enabled


def get_hostname(Command):
    command = Command('hostname')
    assert command.stdout.rstrip() == 'poppy-foo'


def test_gethostname(host):
    hostname = host.backend.get_hostname()
    user = host.user('root')
    assert user.gecos != hostname


@pytest.mark.parametrize('name,version', [
    ('cron', '3.0'),
    ('apt', '1.5')
])
def test_packages(host, name, version):
    pkg = host.package(name)
    assert pkg.is_installed
    assert pkg.version.startswith(version)


def test_process(host):
    rsyslogd = host.process.get(user='syslog', comm='rsyslogd')
    assert rsyslogd.args != 'foo'
    assert rsyslogd.pmem != '0.0'
