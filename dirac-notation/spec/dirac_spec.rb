require_relative '../lib/dirac.rb'

#set vars for rspec
module Variables
  extend RSpec::SharedContext

  let(:bra) { Bra.new('φθ') }
  let(:ket) { Ket.new('φθ') }
  let(:braket) { Braket.new('φ', 'θ') }
  let(:ketbra) { Ketbra.new('φ', 'θ') }
  let(:linear_operator_one) { LinearOperator.new('A') }
  let(:linear_operator_two) { LinearOperator.new('B') }
  let(:conjugated_linear_operator) { LinearOperator.new('~H') }
  let(:waveform) { Waveform.new('rt') }
  let(:bra_linear_operator) { Bra.new(bra.bra_states, linear_operator_one, linear_operator_two, conjugated_linear_operator) }
  let(:ket_linear_operator) { Ket.new(linear_operator_one, linear_operator_two, conjugated_linear_operator, ket.ket_states) }
  let(:braket_linear_operator) { Braket.new(braket.bra_states, linear_operator_one, linear_operator_two, conjugated_linear_operator, braket.ket_states) }
  let(:ketbra_linear_operator) { Ketbra.new(linear_operator_one, linear_operator_two, conjugated_linear_operator, ketbra.ket_states, ketbra.bra_states) }
  let(:waveform_linear_operator) { Waveform.new(linear_operator_one, linear_operator_two, conjugated_linear_operator, waveform.bra_states) }
end

RSpec.configure { |config| config.include Variables }

describe 'Dirac to string tests.' do
  it 'Outputs Bra string correctly.' do
    expect(bra.to_s).to eql('<φθ|')
  end
  it 'Outputs Ket string correctly.' do
    expect(ket.to_s).to eql('|φθ>')
  end
  it 'Outputs Braket string correctly.' do
    expect(braket.to_s).to eql('<φ|θ>')
  end
  it 'Outputs Ketbra string correctly.' do
    expect(ketbra.to_s).to eql('|φ><θ|')
  end
  it 'Waveform converted to braket correctly.' do
    expect((waveform).to_s).to eql('<rt|Ψ>')
  end
  it 'Outputs LinearOperators string correctly.' do
    expect(linear_operator_one.to_s + linear_operator_two.to_s + conjugated_linear_operator.to_s).to eql('AB~H')
  end
  it 'Outputs Bra with linear operator string correctly.' do
    expect(bra_linear_operator.to_s).to eql('<φθ|AB~H')
  end
  it 'Outputs Ket with linear operator string correctly.' do
    expect(ket_linear_operator.to_s).to eql('AB~H|φθ>')
  end
  it 'Outputs Braket with linear operator string correctly.' do
    expect(braket_linear_operator.to_s).to eql('<φ|AB~H|θ>')
  end
  it 'Outputs Ketbra with linear operator string correctly.' do
    expect(ketbra_linear_operator.to_s).to eql('AB~H|φ><θ|')
  end
  it 'Waveform with linear operator converted to braket correctly.' do
    expect((waveform_linear_operator).to_s).to eql('<rt|AB~H|Ψ>')
  end
end

describe 'Dirac inner product tests.' do
  it 'Bra * Bra outputs correctly.' do
    expect((bra * bra).to_s).to eql('<φθφθ|')
  end
  it 'Bra * Bra with linear operator outputs correctly.' do
    expect((bra_linear_operator * bra_linear_operator).to_s).to eql('<φθφθ|AB~HAB~H')
  end
  it 'Bra * Ket outputs correctly.' do
    expect((bra * ket).to_s).to eql('<φθ|φθ>')
  end
  it 'Bra * Ket with linear operator outputs correctly.' do
    expect((bra_linear_operator * ket_linear_operator).to_s).to eql('<φθ|AB~HAB~H|φθ>')
  end
  it 'Bra * Braket outputs correctly.' do
    expect((bra * braket).to_s).to eql('<φθφ|θ>')
  end
  it 'Bra * Braket with linear operator outputs correctly.' do
    expect((bra_linear_operator * braket_linear_operator).to_s).to eql('<φθφ|AB~HAB~H|θ>')
  end
  it 'Bra * Ketbra outputs correctly.' do
    expect((bra * ketbra).to_s).to eql('|φ><φθθ|')
  end
  it 'Bra * Ketbra with linear operator outputs correctly.' do
    expect((bra_linear_operator * ketbra_linear_operator).to_s).to eql('AB~HAB~H|φ><φθθ|')
  end
  it 'Ket * Bra outputs correctly.' do
    expect((ket * bra).to_s).to eql('|φθ><φθ|')
  end
  it 'Ket * Bra with linear operator outputs correctly.' do
    expect((ket_linear_operator * bra_linear_operator).to_s).to eql('AB~HAB~H|φθ><φθ|')
  end
  it 'Ket * Ket outputs correctly.' do
    expect((ket * ket).to_s).to eql('|φθφθ>')
  end
  it 'Ket * Ket with linear operator outputs correctly.' do
    expect((ket_linear_operator * ket_linear_operator).to_s).to eql('AB~HAB~H|φθφθ>')
  end
  it 'Ket * Braket outputs correctly.' do
    expect((ket * braket).to_s).to eql('<φ|φθθ>')
  end
  it 'Ket * Braket with linear operator outputs correctly.' do
    expect((ket_linear_operator * braket_linear_operator).to_s).to eql('<φ|AB~HAB~H|φθθ>')
  end
  it 'Ket * Ketbra outputs correctly.' do
    expect((ket * ketbra).to_s).to eql('|φθφ><θ|')
  end
  it 'Ket * Ketbra with linear operator outputs correctly.' do
    expect((ket_linear_operator * ketbra_linear_operator).to_s).to eql('AB~HAB~H|φθφ><θ|')
  end
end

describe 'Dirac hermitian conjugate tests.' do
  it 'Bra hermitian conjugate outputs correctly.' do
    expect((~bra).to_s).to eql('|φθ>')
  end
  it 'Ket hermitian conjugate outputs correctly.' do
    expect((~ket).to_s).to eql('<φθ|')
  end
  it 'Braket hermitian conjugate outputs correctly.' do
    expect((~braket).to_s).to eql('<θ|φ>')
  end
  it 'Ketbra hermitian conjugate outputs correctly.' do
    expect((~ketbra).to_s).to eql('|θ><φ|')
  end
  it 'Linear operator hermitian conjugate outputs correctly.' do
    expect((~linear_operator_one).to_s).to eql('~A')
  end
  it 'Linear operator hermitian conjugate is recognized as conjugated.' do
    expect((~linear_operator_two).conjugated).to eql(true)
  end
  it 'Bra with linear operator hermitian conjugate outputs correctly.' do
    expect((~bra_linear_operator).to_s).to eql('H~B~A|φθ>')
  end
  it 'Ket with linear operator hermitian conjugate outputs correctly.' do
    expect((~ket_linear_operator).to_s).to eql('<φθ|H~B~A')
  end
  it 'Braket with linear operator hermitian conjugate outputs correctly.' do
    expect((~braket_linear_operator).to_s).to eql('<θ|H~B~A|φ>')
  end
  it 'Ketbra with linear operator hermitian conjugate outputs correctly.' do
    expect((~ketbra_linear_operator).to_s).to eql('H~B~A|θ><φ|')
  end
end
