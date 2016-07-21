require 'yaml'
require_relative '../spec_helper'

describe "#{host_inventory['fqdn']}: Special App is deployed and configured." do
  %w(appserviceone appservicetwo).each do |appservice|
    describe service(appservice) do
      it { expect(subject).to be_running }
    end
  end

  describe user('appuser') do
    it { expect(subject).to exist }
    it { expect(subject).to have_uid 1234 }
    it { expect(subject).to belong_to_group 'users' }
    it { expect(subject).to have_home_directory '/home/appuser' }
    it { expect(subject).to have_login_shell '/usr/bin/ksh' }
    its(:encrypted_password) { is_expected.to match(/^.{13}$/) }
  end

  describe file('/path/to/dir') do
    it { expect(subject).to be_directory }
    it { expect(subject).to be_owned_by 'diruser' }
    it { expect(subject).to be_grouped_into 'diruser' }
    it { expect(subject).to be_mode 777 }
  end

  ['/path/to/one.war', '/path/to/two.war', '/path/to/three.war'].each do |the_file|
    describe file(the_file) do
      it { is_expected.to_not exist }
    end
  end

  describe file('/apache.conf') do
    it { expect(subject).to be_file }
    it { expect(subject).to be_owned_by 'root' }
    it { expect(subject).to be_grouped_into 'root' }
    it { expect(subject).to be_mode 644 }
  end

  describe command('source /env_script; /bin/echo $ENV_VAR') do
    its(:stdout) { is_expected.to_not match(/./) }
  end

  specialapp_version = command('/query/database/for specialapp_version').stdout.chomp
  data = YAML.load_file(File.expand_path("../specialapp_#{specialapp_version}.yaml", __FILE__))

  data['packages'].each do |package, attributes|
    describe package(package) do
      it { expect(subject).to be_installed.with_version(attributes['version']) }
    end
  end

  data['dupe_packages'].each do |package|
    describe command("/bin/rpm -q #{package} | wc -l") do
      its(:stdout) { is_expected.to eql("1\n") }
    end
  end

  data['war_files'].each do |war_package, attributes|
    describe war_package do
      describe file(attributes['file']) do
        its(:size) { is_expected.to eql(attributes['size']) }
      end
    end
  end

  data['dirs'].each do |app_package, attributes|
    describe app_package do
      describe file(attributes['dir']) do
        it { expect(subject).to be_directory }
      end
    end
  end

  data['lib_dirs'].each do |app_package, attributes|
    describe app_package do
      describe file(attributes['dir']) do
        it { expect(subject).to be_directory }
      end

      describe command("/bin/ls -l #{attributes['dir']} | /bin/egrep -c ^-") do
        its(:stdout) { is_expected.to eql("#{attributes['num']}\n") }
      end
    end
  end

  data['absent_dirs'].each do |app_package, attributes|
    describe app_package do
      describe file(attributes['dir']) do
        it { expect(subject).to_not exist }
      end

      describe file(attributes['lib']) do
        it { expect(subject).to_not exist }
      end
    end
  end
end
