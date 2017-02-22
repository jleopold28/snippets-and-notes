#include <string>
#include <iostream>

class Mystring {
private:
  std::string m_string;

public:
  Mystring(const std::string string): m_string{string} {};

  std::string operator()(int index, int length) {
    auto substring = "";

    for (auto i = 0; i < length; ++i)
      substring += m_string[i + index];

    return substring;
  }
};

int main()
{
  Mystring string("Hello, world!");
  std::cout << string(7, 5); // start at index 7 and return 5 characters

  return 0;
}
