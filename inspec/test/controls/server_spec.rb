# inspec exec . --attrs attributes/attributes.yml

role = attribute('role', default: 'base', description: 'type of node that the InSpec profile is testing')

if %w[client base].include?(role)
  control 'Testing only client' do
    title 'Tests for client'
    desc 'The following tests within this control will be used for client nodes.'

    describe user('client') do
      it { expect(subject).to exist }
    end
  end
end

if %w[server base].include?(role)
  control 'Testing only server' do
    title 'Tests for server'
    desc 'The following tests within this control will be used for server nodes.'

    describe user('server') do
      it { expect(subject).to exist }
    end
  end
end
