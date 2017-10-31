require 'serverspec'

set :backend, :docker
set :disable_sudo, true
set :os, family: :redhat
set :docker_image, 'centos/apache:1.0'

describe 'Acceptance Testing CM' do
  describe package('httpd') do
    it { expect(subject).to be_installed }
  end
end
