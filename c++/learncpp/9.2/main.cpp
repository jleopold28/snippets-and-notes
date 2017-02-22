// also 9.3
#include <iostream>

class Fraction {
private:
  int m_num, m_den;

public:
  Fraction() {}

  Fraction(int num, int den): m_num{num}, m_den{den} {
    reduce();
  }

  void print() {
    std::cout << m_num << '/' << m_den << std::endl;
  }

  friend Fraction operator*(const Fraction &one, const Fraction &two) {
    return Fraction(one.m_num * two.m_num, one.m_den * two.m_den);
  }

  friend Fraction operator*(const Fraction &one, int val) {
    return Fraction(one.m_num * val, one.m_den);
  }

  friend Fraction operator*(int val, const Fraction &two) {
    return Fraction(val * two.m_num, two.m_den);
  }

  friend std::ostream& operator<<(std::ostream &out, const Fraction &frac) {
    out << frac.m_num << '/' << frac.m_den;
    return out;
  }

  friend std::istream& operator>>(std::istream &in, Fraction &frac) {
    char slash;
    in >> frac.m_num;
    in >> slash;
    in >> frac.m_den;
    return in;
  }

  static int gcd(int a, int b) {
    return b == 0 ? a : gcd(b, a % b);
  }

  void reduce() {
    auto gcd = Fraction::gcd(m_num, m_den);
    m_num /= gcd;
    m_den /= gcd;
  }
};

int main()
{
  Fraction f1(2, 5);
	f1.print();

	Fraction f2(3, 8);
	f2.print();

	Fraction f3 = f1 * f2;
	f3.print();

	Fraction f4 = f1 * 2;
	f4.print();

	Fraction f5 = 2 * f2;
	f5.print();

	Fraction f6 = Fraction(1, 2) * Fraction(2, 3) * Fraction(3, 4);
	f6.print();

  Fraction f7;
  std::cout << "Enter fraction 1: ";
  std::cin >> f7;

  Fraction f8;
  std::cout << "Enter fraction 2: ";
  std::cin >> f8;

  std::cout << f7 << " * " << f8 << " is " << f7 * f8 << '\n';

  return 0;
}
