# TODO: cannot get the mocking to work with the constructor

describe Logger do
  context '.new' do
    it 'reads in the row name and assigns it to the appropriate class variable' do
      allow(Logger.new('foo')).to receive(:provider) { nil }
      logger = Logger.new('foo')
      allow(logger).to receive(:provider) { nil }
      expect(logger.instance_variable_get(:@name)).to eq('foo')
    end
    it 'stores nil in the appropriate class variable if no information was found for the row name' do
      logger = Logger.new('bar')
      cmd = instance_double('logger stdout object', stdout: '  1.2.3  "baz"               off    asdf')
      allow(logger).to receive(:provider) { cmd }
      expect(instance_variable_get(:@info)).to be nil
    end
    it 'receives an accurate hash of row information from the parser and stores it in the appropriate class variable' do
      logger = Logger.new('baz')
      cmd = instance_double('logger stdout object', stdout: '  1.2.3  "baz"               off    asdf')
      allow(logger).to receive(:provider) { cmd }
      expect(instance_variable_get(:@info)).to eq(type: 'asdf', status: 'off', version:
'1.2.3')
    end
  end

  context '.on?' do
    it 'returns true for an on row' do
      logger = instance_double(Logger)
      allow(logger).to receive(:provider) { true }
      logger.instance_variable_set(:@info, status: 'on')
      expect(logger.on).to be true
    end
    it 'returns false for a off row' do
      logger = Logger.new('baz')
      expect(logger.instance_variable_set(:@info, status: 'off')).to be false
    end
  end

  context '.version' do
    it 'returns the version of a row' do
      logger = Logger.new('baz')
      expect(logger.instance_variable_set(:@info, version: '1.2.3')).to eq('1.2.3')
    end
  end

  context '.type' do
    it 'returns the type of a row' do
      logger = Logger.new('baz')
      expect(logger.instance_variable_set(:@info, type: 'cool')).to eq('cool')
    end
  end
end
