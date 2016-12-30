#include "io.hpp"

int main() {
  int num_one = readNumber();
  int num_two = readNumber();
  writeNumber(num_one + num_two);

  return 0;
}
