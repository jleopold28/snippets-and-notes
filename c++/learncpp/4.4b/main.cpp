#include <iostream>
#include <string>

int main() {
  std::cout << "Enter your full name." << std::endl;
  std::string name;
  std::getline(std::cin, name);

  std::cout << "Enter your age." << std::endl;
  float age;
  std::cin >> age;

  std::cout << "You have lived " << age / name.length() << " years per letter in your name." << std::endl;

  return 0;
}
