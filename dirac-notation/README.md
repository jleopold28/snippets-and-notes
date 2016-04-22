#Ruby Dirac Notation

A Ruby tool for playing around with Dirac notation and doing simple Quantum Mechanics in Hilbert space.  This is meant primarily as a toy and should not be considered seriously.

##API

###LinearOperator(operator)

The operator argument is a string denoting the operator and should be prefixed with '~' to indicate a conjugate.
```
LinearOperator.new('A')
LinearOperator.new('~B')
```
###Bra(states, linear_operators)

The states argument is a string denoting the bra states.  The optional linear_operators arguments are LinearOperator objects.
```
Bra.new('φθ') <--> <φθ|
Bra.new('φθ', LinearOperator.new('A'), LinearOperator.new('~B')) <--> <φθ|A~B
```
###Ket(linear_operators, states)

The optional linear_operators arguments are LinearOperator objects.  The states argument is a string denoting the ket states.
```
Ket.new('φθ') <--> |φθ>
Ket.new(LinearOperator.new('A'), LinearOperator.new('~B'), 'φθ') <--> A~B|φθ>
```
###Braket(bra_states, linear_operators, ket_states)

The bra_states argument is a string denoting the bra states.  The optional linear_operators arguments are LinearOperator objects.  The ket_states argument is a string denoting the ket_states.
```
Braket.new('φ', 'θ') <--> <φ|θ>
Braket.new('φ', LinearOperator.new('A'), LinearOperator.new('~B'), 'θ') <--> <φ|A~B|θ>
```
###Ketbra(linear_operators, ket_states, bra_states)

The ket_states argument is a string denoting the ket states.  The optional linear_operators arguments are LinearOperator objects.  The bra_states argument is a string denoting the bra_states.
```
Ketbra.new('φ', 'θ') <--> |φ><θ|
Ketbra.new(LinearOperator.new('A'), LinearOperator.new('~B'), 'φ', 'θ') <--> A~B|φ><θ|
```
###Waveform(linear_operators, function_of)

The optional linear_operators arguments are LinearOperator objects.  The function_of argument is a string denoting what the waveform is a function of and will be the implied bra states.  The waveform will always be implied as Ψ and the ket state.
```
Waveform.new('rt') <--> <rt|Ψ>
Waveform.new(LinearOperator.new('A'), LinearOperator.new('~B'), 'rt') <--> <rt|A~B|Ψ>
```
###*

The * operator will perform an inner product for Bra/Ket/Braket/Ketbra/Waveform (unfinished for Braket, Ketbra, and Waveform on the left side).
```
Bra.new('φ', LinearOperator.new('A')) * Bra.new('θ', LinearOperator.new('~B')) <--> <φθ|A~B
Ket.new(LinearOperator.new('A'), 'φ') * Ket.new(LinearOperator.new('~B'), 'θ') <--> A~B|φθ>
Bra.new('φ', LinearOperator.new('A')) * Ket.new(LinearOperator.new('~B'), 'θ') <--> <φ|A~B|θ>
```
###~

The ~ operator will perform a Hermitian conjugate for Bra/Ket/Braket/Ketbra/Waveform/LinearOperator.
```
~LinearOperator('A') <--> ~A
~LinearOperator('~B') <--> B
~Bra.new('φθ', LinearOperator.new('A'), LinearOperator.new('~B')) <--> B~A|φθ>
~Ket.new(LinearOperator.new('A'), LinearOperator.new('~B'), 'φθ') <--> <φθ|B~A
~Braket.new('φ', LinearOperator.new('A'), LinearOperator.new('~B'), 'θ') <--> <θ|B~A|φ>
```
