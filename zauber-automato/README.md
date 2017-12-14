# Zauber Autômato
travisci placeholder

CURRENTLY EARLY ALPHA

- **Zauber**: (arcane) magic, auf Deutsch
- **Autômato**: automaton/robot, em Português do Brasil

## Description
Zauber Autômato is a gem that automatically generates Ansible task lists, Chef recipes, and Puppet manifests from your Serverspec tests. It is automatic TDD software for configuration management, orchestration, and automation.

### Example
Serverspec test located at `spec/role_one/package_spec.rb`:

```ruby
require_relative '../spec_helper'

# package
describe package('specinfra') do
  it { expect(subject).to be_installed }
end

# package with version
describe package('zauber-automato') do
  it { expect(subject).to be_installed.with_version('1.0.0') }
end

# package with provider
describe package('puppet-check') do
  it { expect(subject).to be_installed.by('gem') }
end

# package with version and provider
describe package('serverspec') do
  it { expect(subject).to be_installed.by('yum').with_version('2.36.0') }
end
```

Execution command `rake spec/role_one` stdout:

```
Package 'specinfra'
  should be installed

Package 'zauber-automato'
  should be installed with version 1.0.0

Package 'puppet-check'
  should be installed with provider gem

Package 'serverspec'
  should be installed with provider yum with version 2.36.0
```

The following three files are generated:

```yaml
# role_one.yml
- name: install specinfra
  package:
    name: specinfra
    state: present

- name: install zauber-automato
  package:
    name: zauber-automato-1.0.0
    state: present

- name: install puppet-check
  gem:
    name: puppet-check
    state: present

- name: install serverspec
  yum:
    name: serverspec-2.36.0
    state: present
```

```ruby
# role_one.rb
package 'specinfra' do
  action :install
end

package 'zauber-automato' do
  action :install
  version '1.0.0'
end

package 'puppet-check' do
  action :install
  provider Chef::Provider::Package::Gem
end

package 'serverspec' do
  action :install
  version '2.36.0'
  provider Chef::Provider::Package::Yum
end
```

```puppet
# role_one.pp
package { 'specinfra':
  ensure => installed,
}

package { 'zauber-automato':
  ensure => '1.0.0',
}

package { 'puppet-check':
  ensure => installed,
  provider => gem,
}

package { 'serverspec':
  ensure => '2.36.0',
  provider => yum,
}
```


## Usage

warning about not mixing require Serverspec and ZauberAutomato in same spec_helper

## Serverspec Compatibility
Zauber Autômato is currently compatible with as many types and matchers as possible up to Serverspec 2.36.0.

### Type and Matcher Support Table
| Resource  | Matcher | Chains |
| --------- | ------- | ------ |
| Cron      | has/have_entry | with_user |
| File      | exist, file, directory, block_device, symlink, mode, owned_by, grouped_into, linked_to, mounted | device, type, options[rw, mode] |
| Group     | exists, has/have_gid | none |
| Package   | installed  | with_version, with_provider |
| Service   | enabled, running, be_monitored_by, have_start_mode | with_level, under, with_name |
| User      | exists, belong(s)_to_group, belong(s)_to_primary_group, has/have_uid, has/have_home_directory, has/have_login_shell, has/have_authorized_key  | none |

The following are undocumented but supported Serverspec matchers that I would appreciate clarification on if anyone could provide insight.

- **service**: has_property

## Contributing
Code should pass all spec tests. New features should involve new spec tests. Adherence to Rubocop and Reek is expected where not overly onerous or where the check is of dubious cost/benefit.

A [Dockerfile](Dockerfile) is provided for easy rake testing. A [Vagrantfile](Vagrantfile) is provided for easy gem building, installation, and post-installation testing.

Please consult the [CHANGELOG](CHANGELOG.md) for the current development roadmap.
