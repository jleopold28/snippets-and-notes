#include <iostream>

int sumTo(int value) {
  auto sum = 0;
  for (auto i = 0; i < value; ++i)
    sum += value;
  return sum;
}

int main() {
  for (auto i = 0; i < 20; i += 2)
    std::cout << i << std::endl;
}
