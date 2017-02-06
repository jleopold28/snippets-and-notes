#include <iostream>
#include <string>
#include <array>

struct Employee {
  std::string name;
};

int sumTo(int num) {
  auto sum = num;

  while(--num > 0)
    sum += num;

  return sum;
}

void printEmployeeName(const Employee &employee) {
  std::cout << employee.name << std::endl;
}

void minMax(int num_one, int num_two, int &min, int &max) {
  if (num_one > num_two) {
    max = num_one;
    min = num_two;
  }
  else if (num_two > num_one) {
    max = num_two;
    min = num_one;
  }
  else
    std::cout << "Numbers are equal." << std::endl;
}

int getIndexOfLargestValue(const int *array, int size) {
  auto largestValue = array[0];
  auto largestIndex = 0;

  for (auto i = 1; i < size; ++i) {
    if (array[i] > largestValue) {
      largestValue = array[i];
      largestIndex = i;
    }
  }

  return largestIndex;
}

const int& getElement(const int *array, int index) {
  return array[index];
}

int main() {
  std::cout << sumTo(4) << std::endl;

  Employee bob = {"Bob"};
  printEmployeeName(bob);

  int min, max;
  minMax(2, 3, min, max);
  std::cout << min << ' ' << max << std::endl;

  int array[6] = {1, 2, 3, 4 ,5, 6};
  std::cout << getIndexOfLargestValue(array, 6) << std::endl;
  std::cout << getElement(array, 3) << std::endl;

  return 0;
}
