import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_cowsay_installed(host):
    cowsay = host.package('cowsay')

    assert cowsay.is_installed


def test_motd(host):
    motd = host.file('/etc/profile.d/motd.sh')

    assert motd.is_file
    assert motd.user == 'root'
    assert motd.group == 'root'
    assert motd.mode == '0o755'
    assert motd.contains('cowsay')
