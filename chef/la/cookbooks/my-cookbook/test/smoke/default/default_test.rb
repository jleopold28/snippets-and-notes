# # encoding: utf-8

# Inspec test for recipe my-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { expect(subject).to exist }
  end
end

describe package('cowsay') do
  it { expect(subject).to be_installed }
end
