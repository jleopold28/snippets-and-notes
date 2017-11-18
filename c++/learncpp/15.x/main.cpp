#include <iostream>
#include <memory> // for std::shared_ptr

class Resource {
public:
  Resource() { std::cout << "Resource acquired\n"; }
  ~Resource() { std::cout << "Resource destroyed\n"; }
};

class Something {}; // assume Something is a class that can throw an exception

Something doSomething(Something *ptr1, Something *ptr2) {
  return Something();
}

int main() {
  auto ptr1 = std::make_shared<Resource>();
  auto ptr2(ptr1);

  auto somethingPtr = doSomething(std::make_shared<Something>().get(), std::make_shared<Something>().get());

  return 0;
}
