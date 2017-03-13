#include <iostream>
#include <stdexcept>

class Fraction {
private:
  int m_num, m_den;

public:
  Fraction(int num, int den): m_num{num}, m_den{den} {
    if (num == 0)
      throw std::runtime_error("Denominator cannot be 0");
  }

  friend std::ostream& operator<<(std::ostream& out, const Fraction &frac) {
    out << frac.m_num << '/' << frac.m_den;
    return out;
  }
};

int main() {
  int num, den;
  std::cout << "Enter fraction numerator and denominator." << std::endl;
  std::cin >> num;
  std::cin >> den;

  try {
    Fraction frac{num, den};
    std::cout << frac << std::endl;
  }
  catch(std::exception&) {
    std::cout << "Invalid fraction." << std::endl;
  }

  return 0;
}
