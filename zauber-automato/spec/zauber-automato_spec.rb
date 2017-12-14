require_relative 'spec_helper'
require_relative '../lib/zauber-automato'

# TODO: this should be the system test home
describe ZauberAutomato do
  let(:zauberautomato) { ZauberAutomato.new }

  context 'self' do
    it 'types hash can be altered' do
      ZauberAutomato.types = { foo: bar }
      expect(ZauberAutomato.types).to eql(foo: bar)
    end
  end
end
