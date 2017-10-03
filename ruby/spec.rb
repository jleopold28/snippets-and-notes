let(:object) { Class.new(fixtures_dir + 'file') }
let(:method) { object.method }

after(:all) do
  File.delete('file')
end

# private method
expect { Class.new.send(:private_method, arg) }.to_not raise_error

# set/get instance variable
foo.instance_variable_set(:@foo, 12)
foo.instance_variable_get(:@foo)
