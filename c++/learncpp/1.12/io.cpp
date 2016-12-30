#include <iostream>

int readNumber() {
  int n;
  std::cout << "Enter a number:" << std::endl;
  std::cin >> n;
  return n;
}

void writeNumber(int n) {
  std::cout << "Number is: " << n << std::endl;
}
