require 'spec_helper'

describe "#{host_inventory['fqdn']}: Application deployment and configuration checks for role_three." do
  describe 'APP is deployed and configured.' do
    describe user('appuser01') do
      it { expect(subject).to exist }
    end

    describe file('/home/appuser01/.shosts') do
      it { expect(subject).to be_file }
      it { expect(subject).to be_owned_by 'appuser01' }
      it { expect(subject).to be_mode 644 }
    end
  end
end
