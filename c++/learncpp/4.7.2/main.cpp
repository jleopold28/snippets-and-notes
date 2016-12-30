#include <iostream>
#include <string>

struct Fraction {
  int numerator, denominator;
};

Fraction generator() {
  std::cout << "Enter the fraction numerator." << std::endl;
  int numer;
  std::cin >> numer;

  std::cout << "Enter the denominator." << std::endl;
  int denom;
  std::cin >> denom;

  return {numer, denom};
}

Fraction fractionMultiply(Fraction frac_one, Fraction frac_two) {
  return {frac_one.numerator * frac_two.numerator, frac_one.denominator * frac_two.denominator};
}

std::string fractionString(Fraction fraction) {
  return std::to_string(fraction.numerator) + " / " + std::to_string(fraction.denominator);
}

int main() {
  Fraction frac_one = generator();
  Fraction frac_two = generator();

  std::cout << "The product is: " << fractionString(fractionMultiply(frac_one, frac_two)) << std::endl;

  return 0;
}
