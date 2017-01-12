#include <iostream>
#include <string>

int main() {
  const std::string names[] = {"Alex", "Betty", "Caroline", "Dave", "Emily", "Fred", "Greg", "Holly"};

  std::cout << "Input a name." << std::endl;
  std::string input_name;
  std::cin >> input_name;

  auto found = false;
  for (const auto &name : names)
    if (input_name == name) {
      std::cout << input_name << " was in the list." << std::endl;
      found = true;
      break;
    }

  if (!found)
    std::cout << input_name << " was not in the list." << std::endl;

  return 0;
}
