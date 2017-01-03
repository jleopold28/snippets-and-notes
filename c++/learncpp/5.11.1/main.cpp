#include <iostream>
#include <cmath>
#include "constants.hpp"

float inputHeight() {
  std::cout << "Input height (meters) of the tower the ball is dropped from." << std::endl;
  float height;
  std::cin >> height;
  return height;
}

float currentHeight(float init_height, float time_s) {
  return init_height - (constants::gravity * std::pow(time_s, 2) / 2);
}

void displayHeight(float init_height) {
  for (auto t = 0; currentHeight(init_height, t) > 0; ++t)
    std::cout << "Height at " << t << " seconds is: " << currentHeight(init_height, t) << std::endl;
  std::cout << "Ball hits the ground at the next second." << std::endl;
}

int main() {
  auto height = inputHeight();
  displayHeight(height);

  return 0;
}
