#include <string>
#include <iostream>

class Fruit {
private:
  std::string m_name, m_color;

public:
  Fruit(std::string name, std::string color): m_name{name}, m_color{color} {}

  friend std::ostream& operator<<(std::ostream &out, const Fruit &fruit) {
    out << "Fruit (name: " << fruit.m_name << ", color: " << fruit.m_color << ')';
    return out;
  }

  std::string getName() const { return m_name; }
  std::string getColor() const { return m_color; }
};

class Apple: public Fruit {
public:
  Apple(std::string color): Fruit{"apple", color} {}

  Apple(std::string name, std::string color): Fruit{name, color} {}

  friend std::ostream& operator<<(std::ostream &out, const Apple &apple) {
    out << "Apple (name: " << apple.getName() << ", color: " << apple.getColor() << ')';
    return out;
  }
};

class GrannySmith: public Apple {
public:
  GrannySmith(): Apple{"granny smith apple", "green"} {}
};

class Banana: public Fruit {
public:
  Banana(): Fruit{"banana", "yellow"} {}

  Banana(std::string name, std::string color): Fruit{name, color} {}

  friend std::ostream& operator<<(std::ostream &out, const Banana &banana) {
    out << "Banana (name: " << banana.getName() << ", color: " << banana.getColor() << ')';
    return out;
  }
};

int main() {
	Apple a("red");
	Banana b;
  GrannySmith c;

	std::cout << "My " << a.getName() << " is " << a.getColor() << '.' << std::endl;
	std::cout << "My " << b.getName() << " is " << b.getColor() << '.' << std::endl;
  std::cout << "My " << c.getName() << " is " << c.getColor() << '.' << std::endl;

	return 0;
}
