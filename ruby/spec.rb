let(:object) { Class.new(fixtures_dir + 'file') }
let(:method) { object.method }

after(:all) do
  File.delete('file')
end
