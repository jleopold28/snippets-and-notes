require 'spec_helper'

require_relative 'specialapp.rb'

describe "#{host_inventory['fqdn']}: Application deployment and configuration checks for bb_role_one." do
  describe 'APP is deployed and configured.' do
    describe service('appservice') do
      it { expect(subject).to be_running }
    end

    describe user('appuser01') do
      it { expect(subject).to exist }
      it { expect(subject).to have_uid 1234 }
      it { expect(subject).to belong_to_group 'users' }
      it { expect(subject).to have_home_directory '/home/appuser01' }
      it { expect(subject).to have_login_shell '/usr/bin/ksh' }
      its(:encrypted_password) { is_expected.to match(/^.{13}$/) }
    end

    describe file('/dataload') do
      it { expect(subject).to be_directory }
      it { expect(subject).to be_owned_by 'datauser01' }
      it { expect(subject).to be_grouped_into 'databasegroup' }
    end
  end

  describe 'APP is deployed and configured.' do
    %w(appserviceone appservicetwo appservicethree).each do |the_service|
      describe service(the_service) do
        it { expect(subject).to be_running }
      end
    end

    describe file('/app/data') do
      it { expect(subject).to be_directory }
      it { expect(subject).to be_owned_by 'datauser' }
      it { expect(subject).to be_grouped_into 'datauser' }
    end

    describe file('/home/datauser/.ssh/id_rsa') do
      it { expect(subject).to be_file }
      it { expect(subject).to be_owned_by 'datauser' }
      it { expect(subject).to be_grouped_into 'root' }
      it { expect(subject).to be_mode 600 }
    end

    ["http.#{ENV['SERVER_ID']}.key", 'http.key'].each do |httpkey|
      describe file('/HTTPServer/keys/' + httpkey) do
        it { expect(subject).to be_file }
        it { expect(subject).to be_owned_by 'root' }
        it { expect(subject).to be_grouped_into 'sys' }
        it { expect(subject).to be_mode 644 }
      end
    end
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
    %w(appserviceone appservicetwo).each do |appservice|
      describe service(appservice) do
        it { expect(subject).to be_running }
      end
    end
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
    ['/appuser/aa', '/appuser/AA']. each do |dir|
      describe file(dir) do
        it { expect(subject).to be_directory }
        it { expect(subject).to be_owned_by 'appuser' }
        it { expect(subject).to be_grouped_into 'users' }
      end
    end
  end

  describe 'APP is deployed and configured.' do
    describe service('appservice') do
      it { expect(subject).to be_running }
    end

    ['/client.reg', '/client.reg.state', '/keycache.abc']. each do |filename|
      describe file(filename) do
        it { expect(subject).to be_owned_by 'appuser' }
        it { expect(subject).to be_grouped_into 'appuser' }
      end
    end
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
  end
end
