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
  float height = init_height - (constants::gravity * std::pow(time_s, 2) / 2);
  if (height >= 0.0) {
    return height;
  }
  else {
    return 0;
  }
}

void displayHeight(float init_height) {
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 0) << std::endl;
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 1) << std::endl;
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 2) << std::endl;
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 3) << std::endl;
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 4) << std::endl;
  std::cout << "Height at zero seconds is: " << currentHeight(init_height, 5) << std::endl;
}

int main() {
  float height = inputHeight();
  displayHeight(height);

  return 0;
}
