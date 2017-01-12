#include <iostream>

int main() {
  int array[9] = {6, 3, 2, 9, 7, 1, 5, 4, 8};
  auto length = sizeof(array)/sizeof(array[0]);

  for (auto i = 1; i < length; ++i) {
    auto swap = false;

    for (auto j = 0; j < length - i; ++j)
      if (array[j-1] > array[j]) {
        std::swap(array[j-1], array[j]);
        swap = true;
      }

    if (!swap) {
      std::cout << "Terminated on iteration " << i << std::endl;
      break;
    }
  }

  for (auto i = 0; i < length; ++i)
    std::cout << array[i] << ' ';

  std::cout << std::endl;

  return 0;
}
