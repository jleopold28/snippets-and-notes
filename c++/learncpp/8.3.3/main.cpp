#include <iostream>
#include <cassert>

class Stack {
  int m_array[10];
  int m_length = 0;

public:
  void reset() {
    m_length = 0;
    for (auto i = 0; i < 10; ++i)
      m_array[i] = 0;
  }

  bool push(int value) {
    if (m_length == 10)
      return false;

    m_array[m_length++] = value;
    return true;
  }

  int pop() {
    assert(m_length > 0);

    return m_array[--m_length];
  }

  void print() {
    for (auto i = 0; i < m_length; ++i)
      std::cout << m_array[i] << ' ';

    std::cout << std::endl;
  }
};

int main()
{
	Stack stack;
	stack.reset();

	stack.print();

	stack.push(5);
	stack.push(3);
	stack.push(8);
	stack.print();

	stack.pop();
	stack.print();

	stack.pop();
	stack.pop();

	stack.print();

	return 0;
}
