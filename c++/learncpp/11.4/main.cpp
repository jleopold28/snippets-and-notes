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
private:
  double m_fiber;

public:
  Apple(std::string name, std::string color, double fiber): Fruit{name, color}, m_fiber{fiber} {}

  friend std::ostream& operator<<(std::ostream &out, const Apple &apple) {
    out << "Apple (name: " << apple.getName() << ", color: " << apple.getColor() << ", fiber: " << apple.m_fiber << ')';
    return out;
  }
};

class Banana: public Fruit {
public:
  Banana(std::string name, std::string color): Fruit{name, color} {}

  friend std::ostream& operator<<(std::ostream &out, const Banana &banana) {
    out << "Banana (name: " << banana.getName() << ", color: " << banana.getColor() << ')';
    return out;
  }
};

int main()
{
	const Apple a("Red delicious", "red", 4.2);
	std::cout << a << std::endl;

	const Banana b("Cavendish", "yellow");
	std::cout << b << std::endl;

	return 0;
}
