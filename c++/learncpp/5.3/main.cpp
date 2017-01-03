#include <iostream>
#include <string>

enum class Animal {
  PIG,
  CHICKEN,
  GOAT,
  CAT,
  DOG,
  OSTRICH
};

std::string getAnimalName(Animal animal) {
  switch(animal) {
    case Animal::PIG:
      return "Pig";
    case Animal::CHICKEN:
      return "Chicken";
    case Animal::GOAT:
      return "Goat";
    case Animal::CAT:
      return "Cat";
    case Animal::DOG:
      return "Dog";
    case Animal::OSTRICH:
      return "Ostrich";
    default:
      return "Invalid animal.";
  }
}

int numberOfLegs(Animal animal) {
  switch(animal) {
    case Animal::PIG:
    case Animal::GOAT:
    case Animal::CAT:
    case Animal::DOG:
      return 4;
    case Animal::CHICKEN:
    case Animal::OSTRICH:
      return 2;
    default:
      std::cout << "Invalid animal." << std::endl;
      return 0;
  }
}

int calculate(int x, int y, char oper) {
  switch(oper) {
    case '+': {
      return x + y;
    }
    case '-': {
      return x - y;
    }
    case '*': {
      return x * y;
    }
    case '/': {
      return x / y;
    }
    case '%': {
      return x % y;
    }
    default: {
      std::cout << "Invalid operator." << std::endl;
      return 0;
    }
  }
}

int main() {
  return 0;
}
