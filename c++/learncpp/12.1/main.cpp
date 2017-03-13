#include <string>
#include <iostream>

class Animal {
protected:
    std::string m_name;
    const char* m_speak;

    Animal(std::string name, const char* speak): m_name{name}, m_speak{speak} {}

public:
    std::string getName() { return m_name; }
    const char* speak() { return m_speak; }
};

class Cat: public Animal {
public:
    Cat(std::string name): Animal{name, "Meow"} {}
};

class Dog: public Animal {
public:
    Dog(std::string name): Animal{name, "Woof"} {}
};

int main() {
    Cat fred("Fred"), misty("Misty"), zeke("Zeke");
    Dog garbo("Garbo"), pooky("Pooky"), truffle("Truffle");

    Animal *animals[] = { &fred, &garbo, &misty, &pooky, &truffle, &zeke };
    for (auto i=0; i < 6; i++)
        std::cout << animals[i]->getName() << " says " << animals[i]->speak() << std::endl;

    return 0;
}
