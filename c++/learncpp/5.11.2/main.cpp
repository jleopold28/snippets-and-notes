#include <iostream>
#include <random>

int main() {
  std::random_device rd;
  std::mt19937 mersenne(rd());
  auto rdm_num = mersenne() % 101;
  int guess;

  for (auto tries = 0; tries < 7; ++tries) {
    std::cout << "Number of tries thus far: " << tries << "/7." << std::endl;
    std::cout << "Guess a number from 1 to 100." << std::endl;
    std::cin >> guess;

    if (guess > rdm_num)
      std::cout << "Too high." << std::endl;
    else if (guess < rdm_num)
      std::cout << "Too low." << std::endl;
    else if (guess == rdm_num) {
      std::cout << "You win." << std::endl;
      return 0;
    }
    else
      std::cout << "Invalid guess." << std::endl;
  }

  std::cout << "You lose. Correct number was: " << rdm_num << std::endl;

  return 0;
}
