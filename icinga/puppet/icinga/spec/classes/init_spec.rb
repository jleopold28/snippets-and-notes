require 'spec_helper'

describe 'icinga' do
  context 'when deployed on a generic system' do
    it { is_expected.to contain_class('icinga') }
    it { is_expected.to compile.with_all_deps }
  end
end
