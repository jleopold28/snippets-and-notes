#include <iostream>

int factorial(int num) {
  if (num <= 1)
    return 1;
  else
    return num * factorial(num - 1);
}

int sum(int num) {
  if (num < 10)
		return num;
	else
		return sum(num / 10) + (num % 10);
}

void printBinary(int num) {
  if (num <= 0)
    return;

	printBinary(num / 2);

	std::cout << (num % 2);
}

int main() {
  std::cout << factorial(5) << std::endl;
  std::cout << sum(93427) << std::endl;

  int num;
  std::cout << "Enter an integer." << std::endl;
  std::cin >> num;

  printBinary(num);
  std::cout << std::endl;

  return 0;
}
