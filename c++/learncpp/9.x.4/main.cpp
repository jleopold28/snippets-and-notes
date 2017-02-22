#include <iostream>
#include <cstdint>
#include <cmath>

class FixedPoint2 {
private:
  std::int16_t m_base;
  std::int8_t m_decimal;

public:
  FixedPoint2(std::int16_t base, std::int8_t decimal): m_base{base}, m_decimal{decimal} {}

  FixedPoint2(double doub) {
    m_base = static_cast<int16_t>(doub);
    m_decimal = static_cast<int8_t>(round((doub - m_base) * 100));
  }

  operator double() const {
    return m_base + (static_cast<double>(m_decimal) / 100);
  }

  friend bool operator==(const FixedPoint2 &fixed_point, const FixedPoint2 &fixed_point_two) {
    return (fixed_point.m_base == fixed_point_two.m_base && fixed_point.m_decimal == fixed_point_two.m_decimal);
  }

  FixedPoint2 operator-() {
    return FixedPoint2(-m_base, -m_decimal);
  }

  friend FixedPoint2 operator+(const FixedPoint2 &fixed_point, const FixedPoint2 &fixed_point_two) {
    return FixedPoint2(fixed_point.m_base + fixed_point_two.m_base, fixed_point.m_decimal + fixed_point_two.m_decimal);
  }

  friend std::ostream& operator<<(std::ostream &out, const FixedPoint2 &fixed_point) {
    out << static_cast<double>(fixed_point);
    return out;
  }

  friend std::istream& operator>>(std::istream &in, const FixedPoint2 &fixed_point) {
    double doub;
    in >> doub;
    fixed_point = FixedPoint2(doub);

    return in;
  }
};

void testAddition()
{
	std::cout << std::boolalpha;
	std::cout << (FixedPoint2(0.75) + FixedPoint2(1.23) == FixedPoint2(1.98)) << std::endl; // both positive, no decimal overflow
	std::cout << (FixedPoint2(0.75) + FixedPoint2(1.50) == FixedPoint2(2.25)) << std::endl; // both positive, with decimal overflow
	std::cout << (FixedPoint2(-0.75) + FixedPoint2(-1.23) == FixedPoint2(-1.98)) << std::endl; // both negative, no decimal overflow
	std::cout << (FixedPoint2(-0.75) + FixedPoint2(-1.50) == FixedPoint2(-2.25)) << std::endl; // both negative, with decimal overflow
	std::cout << (FixedPoint2(0.75) + FixedPoint2(-1.23) == FixedPoint2(-0.48)) << std::endl; // second negative, no decimal overflow
	std::cout << (FixedPoint2(0.75) + FixedPoint2(-1.50) == FixedPoint2(-0.75)) << std::endl; // second negative, possible decimal overflow
	std::cout << (FixedPoint2(-0.75) + FixedPoint2(1.23) == FixedPoint2(0.48)) << std::endl; // first negative, no decimal overflow
	std::cout << (FixedPoint2(-0.75) + FixedPoint2(1.50) == FixedPoint2(0.75)) << std::endl; // first negative, possible decimal overflow
}

int main()
{
  FixedPoint2 a(34, 56);
	std::cout << a << std::endl;

	FixedPoint2 b(0, -8);
	std::cout << b << std::endl;

	std::cout << static_cast<double>(b) << std::endl;

	FixedPoint2 c(0.01);
	std::cout << c << std::endl;

	FixedPoint2 d(-0.01);
	std::cout << d << std::endl;

	FixedPoint2 e(5.01); // stored as 5.0099999... so we'll need to round this
	std::cout << e << std::endl;

	FixedPoint2 f(-5.01); // stored as -5.0099999... so we'll need to round this
	std::cout << f << std::endl;

  testAddition();

	FixedPoint2 g(-0.48);
	std::cout << g << std::endl;

	std::cout << -g << std::endl;

	std::cout << "Enter a number: "; // enter 5.678
	std::cin >> g;

	std::cout << "You entered: " << g << std::endl;

	return 0;
}
