require 'spec_helper'

describe 'custom::catalog' do
  let(:title) { 'catalog test' }

  context "with test_class_array => ['three dummy classes']" do
    let(:params) { { classes: %w(dummy::classone dummy::classtwo dummy::classthree) } }

    it { is_expected.to contain_custom__catalog('catalog test').with_classes(%w(dummy::classone dummy::classtwo dummy::classthree)) }

    it { is_expected.to contain_class('dummy::classone') }
    it { is_expected.to contain_class('dummy::classtwo').that_requires('Class[dummy::classone]') }
    it { is_expected.to contain_class('dummy::classthree').that_requires('Class[dummy::classtwo]') }
  end
end
