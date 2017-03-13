#include <iostream>
#include <string>

template <class T>
class Pair1 {
private:
  T m_x, m_y;

public:
  Pair1(const T& x, const T& y): m_x{x}, m_y{y} {}

  T& first() { return m_x; }
  const T& first() const { return m_x; }

  T& second() { return m_y; }
  const T& second() const { return m_y; }
};

template <class T, class S>
class Pair {
private:
  T m_x;
  S m_y;

public:
  Pair(const T& x, const S& y): m_x{x}, m_y{y} {}

  T& first() { return m_x; }
  const T& first() const { return m_x; }

  S& second() { return m_y; }
  const S& second() const { return m_y; }
};

template <class T>
class StringValuePair: public Pair<std::string, T> {
public:
  StringValuePair(const std::string& key, const T& value): Pair<std::string, T>(key, value) {}
};

int main() {
	Pair1<int> p1(5, 8);
	std::cout << "Pair: " << p1.first() << ' ' << p1.second() << std::endl;

	const Pair1<double> p2(2.3, 4.5);
	std::cout << "Pair: " << p2.first() << ' ' << p2.second() << std::endl;

  Pair<int, double> p3(5, 6.7);
	std::cout << "Pair: " << p3.first() << ' ' << p3.second() << std::endl;

	const Pair<double, int> p4(2.3, 4);
	std::cout << "Pair: " << p4.first() << ' ' << p4.second() << std::endl;

  StringValuePair<int> svp("Hello", 5);
	std::cout << "Pair: " << svp.first() << ' ' << svp.second() << std::endl;

	return 0;
}
