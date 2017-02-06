#include <iostream>
#include <array>
// #include <functional>

// std::function<int(int, int)> arithmeticFcn;
typedef int (*arithmeticFcn) (int, int);

struct arithmeticStruct {
  char oper;
  arithmeticFcn fcn;
};

int add(int x, int y) {
  return x + y;
}

int subtract(int x, int y) {
  return x - y;
}

int multiply(int x, int y) {
  return x * y;
}

int divide(int x, int y) {
  return x / y;
}

static std::array<arithmeticStruct,4> arithmeticArray {{
  { '+', add },
  { '-', subtract },
  { '*', multiply },
  { '/', divide }
}};

arithmeticFcn getArithmeticFcn(char oper) {
  for (const auto &arithFcn : arithmeticArray)
    if (arithFcn.oper == oper)
      return arithFcn.fcn;
}

int main() {
  double num_one, num_two;
  char oper;

  std::cout << "Enter first number." << std::endl;
  std::cin >> num_one;
  std::cout << "Enter second number." << std::endl;
  std::cin >> num_two;
  std::cout << "Enter operator (+, -, *, /)" << std::endl;
  std::cin >> oper;

  arithmeticFcn fcn = getArithmeticFcn(oper);
  std::cout << num_one << ' ' << oper << ' ' << num_two << " = " << fcn(num_one, num_two) << std::endl;

  return 0;
}
