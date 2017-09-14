require_relative '../libraries/cmd_arg'

describe CMDArg do
  context '.new' do
    it 'reads in the cmd and arg and assigns them to the appropriate class variables' do
      expect(CMDArg.new('cmd').instance_variable_get(:@cmd)).to eq('cmd')
      expect(CMDArg.new('cmd', 'arg').instance_variable_get(:@arg)).to eq('arg')
    end
  end

  context '.arg' do
    it 'returns a string for a version command on linux' do
      cmd_arg = CMDArg.new('python', '--version')
      cmd = instance_double('python version output object', stdout: 'Python version 1.2.3')
      allow(cmd_arg).to receive(:provider) { cmd }
      expect(cmd_arg.arg).to eq('1.2.3')
    end
    it 'returns a string for a version command on windows' do
      cmd_arg = CMDArg.new('java', '-V')
      cmd = instance_double('java version output object', stdout: "java version \"1.9.0_23\"\nJava<TM> SE Runtime Environment <build 1.9.0_23-b12>\nJava HotSpot<TM> 64-Bit Server VM <build 26.25-b02, mixed mode>")
      allow(cmd_arg).to receive(:provider) { cmd }
      expect(cmd_arg.arg).to eq('1.9.0_23')
    end
    it 'returns nil for bad commands' do
      cmd_arg = CMDArg.new('foo')
      allow(cmd_arg).to receive(:provider) { nil }
      expect(cmd_arg.arg).to be_nil
    end
  end

  # this was for the version of the code that checked for more than existence and used the provider; it does not technically validate for the current code
  context '.exist?' do
    it 'returns true for existing commands on linux' do
      cmd_arg = CMDArg.new('echo', 'hello world')
      cmd = instance_double('echo output object', stdout: 'hello world')
      allow(cmd_arg).to receive(:provider) { cmd }
      expect(cmd_arg.exist?).to be true
    end
    it 'returns true for existing commands on windows' do
      cmd_arg = CMDArg.new('ls', '.')
      cmd = instance_double('ls output object', stdout: '\C:')
      allow(cmd_arg).to receive(:provider) { cmd }
      expect(cmd_arg.exist?).to be true
    end
    it 'returns false for commands that do not exist' do
      cmd_arg = CMDArg.new('foo')
      allow(cmd_arg).to receive(:provider) { nil }
      expect(cmd_arg.exist?).to be false
    end
  end
end
