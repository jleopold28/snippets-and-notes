#include <iostream>

int numInput() {
  std::cout << "Enter a number." << std::endl;
  double n;
  std::cin >> n;
  return n;
}

char operInput() {
  std::cout << "Enter +, -, *, or /." << std::endl;
  char oper;
  std::cin >> oper;
  return oper;
}

void doMath(double n1, double n2, char oper) {
  if (oper == '+') {
    std::cout << "The result is: " << n1 + n2 << std::endl;
  }
  else if (oper == '-') {
    std::cout << "The result is: " << n1 - n2 << std::endl;
  }
  else if (oper == '*') {
    std::cout << "The result is: " << n1 * n2 << std::endl;
  }
  else if (oper == '/') {
    std::cout << "The result is: " << n1 / n2 << std::endl;
  }
}

int main() {
  double num_one = numInput();
  double num_two = numInput();
  char oper = operInput();
  doMath(num_one, num_two, oper);

  return 0;
}
