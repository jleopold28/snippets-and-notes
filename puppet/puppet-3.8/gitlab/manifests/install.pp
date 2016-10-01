class gitlab::install() {
  package { ['system-config-firewall-base', 'openssh-server', 'postfix', 'cronie', 'gitlab']: }
}
