require 'rspec'
require_relative '../lib/secure'

describe Secure do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

#  let(:secure) { Secure.new('fixtures/foo.yml', 'fixtures/key.txt', 'fixtures/nonce.txt', 'fixtures/tag.txt') }

  context '.cli' do
    it 'correctly parses the user arguments for encrypt' do
      Secure.cli(%w[-e -f file.txt -k key.txt -n nonce.txt])
      expect(Secure.instance_variable_get(:@settings)).to eq(action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt')
    end
    it 'correctly parses the arguments for decrypt' do
      Secure.cli(%w[-d -f file.txt -k key.txt -n nonce.txt -t tag.txt])
      expect(Secure.instance_variable_get(:@settings)).to eq(action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
    end
  end

  context '.process' do
    it 'raises an error for a missing argument to encrypt' do
      Secure.instance_variable_set(:@settings, action: :encrypt, file: 'a', key: 'b')
      expect { Secure.process }.to raise_error('File, key, and nonce arguments are required for encryption.')
    end
    it 'raises an error for a missing argument to decrypt' do
      Secure.instance_variable_set(:@settings, action: :decrypt, file: 'a', key: 'b', nonce: 'c')
      expect { Secure.process }.to raise_error('File, key, nonce, and tag arguments are required for decryption.')
    end
    it 'raises an error for a missing action' do
      Secure.instance_variable_set(:@settings, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { Secure.process }.to raise_error('Action must be one of generate, encrypt, or decrypt.')
    end
    it 'raises an error for a nonexistent input file' do
      Secure.instance_variable_set(:@settings, action: :encrypt, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { Secure.process }.to raise_error('Input file is not an existing file.')
    end
    it 'reads in all input files correctly for decryption' do
      #
    end
  end

  context '.generate' do
    it 'generates the key and nonce files from the cli' do
      Secure.generate
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true
    end
  end

  context '.encrypt' do
    it 'outputs an encrypted file with the key and nonce from the cli' do
      Secure.instance_variable_set(:@settings, ui: :cli, file: "foo: bar\n", key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n")
      Secure.encrypt
      expect(File.file?('tag.txt')).to be true
      expect(File.file?('encrypted.txt')).to be true
    end
    it 'outputs an array of encrypted content and tag with the key and nonce from the api' do
      Secure.instance_variable_set(:@settings, ui: :api, file: "foo: bar\n", key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n")
      expect(Secure.encrypt).to be_a(Array)
    end
  end

  context '.decrypt' do
    it 'outputs a decrypted file with the key, nonce, and tag from the cli' do
      Secure.instance_variable_set(:@settings, ui: :cli, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: File.read('tag.txt'))
      Secure.decrypt
      expect(File.file?('decrypted.txt')).to be true
      expect(File.read('decrypted.txt')).to eq("foo: bar\n")
    end
    it 'outputs decrypted content with the key, nonce, and tag from the api' do
      Secure.instance_variable_set(:@settings, ui: :api, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: File.read('tag.txt'))
      expect(Secure.decrypt).to be_a(String)
    end
    it 'raises an error for an invalid tag size' do
      Secure.instance_variable_set(:@settings, file: File.read('encrypted.txt'), key: "%+�R`��Znv���[�Sz�(�C`��m�\n", nonce: "y�[�H���K��\n", tag: "�a����e�O_H|�\n")
      expect { Secure.decrypt }.to raise_error('Tag is not 16 bytes.')
    end
  end
end
