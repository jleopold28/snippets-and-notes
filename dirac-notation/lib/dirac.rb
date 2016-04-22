# TODO : should bra and ket waves be combined during multiplication (if not then args to bra/ket should be string and not array and two arrays of strings to braket)?
# TODO : should methods be abstracted into module and included in classes (i could have autodetect logic to determine what was input)?
# TODO : def+
# TODO : revisit def* as it currently breaks math
# TODO : use self instead of creating new @ vars
# TODO : rakefile for spec, rubocop, reek

# dirac notation bra
class Bra
  attr_reader :bra_states, :operators

  def initialize(bra_states, *operators)
    @bra_states = bra_states
    @operators = operators.flatten
  end

  def *(other)
    case other
    when Bra then Bra.new(@bra_states + other.bra_states, @operators.concat(other.operators))
    when Ket then Braket.new(@bra_states, @operators.concat(other.operators), other.ket_states)
    when Braket then Braket.new(@bra_states + other.bra_states, @operators.concat(other.operators), other.ket_states)
    when Ketbra then Ketbra.new(operators.concat(other.operators), other.ket_states, @bra_states + other.bra_states)
    end
  end

  def ~
    Ket.new(@operators.reverse.collect(&:~), @bra_states)
  end

  def to_s
    operators.empty? ? "<#{@bra_states}|" : "<#{@bra_states}|#{@operators.join('')}"
  end
end

# dirac notation ket
class Ket
  attr_reader :ket_states, :operators

  def initialize(*operators, ket_states)
    @operators = operators.flatten
    @ket_states = ket_states
  end

  def *(other)
    case other
    when Bra then Ketbra.new(@operators.concat(other.operators), @ket_states, other.bra_states)
    when Ket then Ket.new(@operators.concat(other.operators), @ket_states + other.ket_states)
    when Braket then Braket.new(other.bra_states, @operators.concat(other.operators), @ket_states + other.ket_states)
    when Ketbra then Ketbra.new(@operators.concat(other.operators), @ket_states + other.ket_states, other.bra_states)
    end
  end

  def ~
    Bra.new(@ket_states, @operators.reverse.collect(&:~))
  end

  def to_s
    operators.empty? ? "|#{@ket_states}>" : "#{@operators.join('')}|#{@ket_states}>"
  end
end

# dirac notation braket
class Braket
  attr_reader :bra_states, :operators, :ket_states

  def initialize(bra_states, *operators, ket_states)
    @bra_states = bra_states
    @operators = operators.flatten
    @ket_states = ket_states
  end

  # TODO : def *

  def ~
    Braket.new(@ket_states, @operators.reverse.collect(&:~), @bra_states)
  end

  def to_s
    @operators.empty? ? "<#{@bra_states}|#{@ket_states}>" : "<#{@bra_states}|#{@operators.join('')}|#{@ket_states}>"
  end
end

# dirac notation ketbra
class Ketbra
  attr_reader :operators, :ket_states, :bra_states

  def initialize(*operators, ket_states, bra_states)
    @operators = operators.flatten
    @ket_states = ket_states
    @bra_states = bra_states
  end

  # TODO : def *

  def ~
    Ketbra.new(@operators.reverse.collect(&:~), @bra_states, @ket_states)
  end

  def to_s
    operators.empty? ? "|#{@ket_states}><#{@bra_states}|" : "#{@operators.join('')}|#{@ket_states}><#{@bra_states}|"
  end
end

# dirac notation waveform
class Waveform < Braket
  # TODO : add multiple function_of (r,t)
  def initialize(*operators, bra_states)
    @operators = operators.flatten
    @bra_states = bra_states
    @ket_states = 'Ψ'
  end
end

# dirac notation linear operators
class LinearOperator
  attr_reader :operator, :conjugated

  def initialize(operator)
    @conjugated = (operator[0] == '~' ? true : false)
    @operator = operator
  end

  # TODO : def *(other)

  def to_s
    @operator.to_s
  end

  def ~
    @operator[0] == '~' ? LinearOperator.new(@operator.delete('~')) : LinearOperator.new('~' + @operator)
  end
end
