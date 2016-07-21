require 'spec_helper'

describe "#{host_inventory['fqdn']}: Application deployment and configuration checks for aa_role_one." do
  describe 'APP is deployed and configured.' do
    describe service('appservice') do
      it { expect(subject).to be_running }
    end
  end

  describe 'APP is deployed and configured.' do
    describe service('appservice') do
      it { expect(subject).to be_running }
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

    describe file('/home/appuser/.ssh/id_rsa') do
      it { expect(subject).to be_file }
      it { expect(subject).to be_owned_by 'appuser' }
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
    ['/appuser/aa', '/appuser/AA']. each do |dir|
      describe file(dir) do
        it { expect(subject).to be_directory }
        it { expect(subject).to be_owned_by 'appuser' }
        it { expect(subject).to be_grouped_into 'users' }
        it { expect(subject).to be_mode 777 }
      end
    end

    ['/appuser/files_aa', '/appuser/files_bb']. each do |dir|
      describe file(dir) do
        it { expect(subject).to be_directory }
        it { expect(subject).to be_mode 777 }
      end
    end
  end

  describe 'APP is deployed and configured.' do
    describe service('appservice') do
      it { expect(subject).to be_running }
    end
  end

  describe 'APP is deployed and configured.' do
  end

  describe 'APP is deployed and configured.' do
  end
end
