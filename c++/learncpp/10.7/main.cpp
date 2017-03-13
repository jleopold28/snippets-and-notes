#include <cassert> // for assert()
#include <initializer_list> // for std::initializer_list
#include <iostream>

class IntArray {
private:
	int m_length, *m_data;

public:
	IntArray(): m_length{0}, m_data{nullptr} {}

	IntArray(int length):	m_length{length} {
		m_data = new int[length];
	}

	IntArray(const std::initializer_list<int> &list): IntArray(list.size())	{
		auto count = 0;

		for (auto &element: list) {
			m_data[count] = element;
			++count;
		}
	}

	~IntArray() {
		delete[] m_data;
	}

  IntArray& operator=(const std::initializer_list<int> &list) {
    if (list.size() != m_length) {
      delete m_data;

      m_length = list.size();
      m_data = new int[m_length];
    }

    auto count = 0;
    for (auto &element: list) {
      m_data[count] = element;
      ++count;
    }
  }

	int& operator[](int index) {
		assert(index >= 0 && index < m_length);
		return m_data[index];
	}

	int getLength() { return m_length; }
};

int main() {
  IntArray array { 5, 4, 3, 2, 1 }; // initializer list
	for (int count = 0; count < array.getLength(); ++count)
		std::cout << array[count] << ' ';

	std::cout << std::endl;

	array = { 1, 3, 5, 7, 9, 11 };

	for (int count = 0; count < array.getLength(); ++count)
		std::cout << array[count] << ' ';

  std::cout << std::endl;

	return 0;
}
