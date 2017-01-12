#include <iostream>

enum class Item {
  HEALTH_POTION,
  TORCH,
  ARROW
};

int countTotalItems(int *items) {
  return items[0] + items[1] + items[2];
}

int main() {
  int items[3] = {2, 5, 10};

  std::cout << "Total number of items is: " << countTotalItems(items) << std::endl;

  return 0;
}
