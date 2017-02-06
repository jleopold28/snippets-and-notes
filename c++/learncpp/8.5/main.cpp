#include <iostream>
#include <string>
#include <cstdint>

class Ball {
private:
  std::string m_color = "Black";
  double m_radius = 10.0;

public:
  Ball() {}

  Ball(std::string color): m_color{color} {}

  Ball(double radius): m_radius{radius} {}

  Ball(std::string color, double radius): m_color{color}, m_radius{radius} {}

  void print() {
    std::cout << "The ball has color " << m_color << " and radius " << m_radius << std::endl;
  }
};

class RGBA {
private:
  std::uint8_t m_red, m_green, m_blue, m_alpha;

public:
  RGBA(std::uint8_t red = 0, std::uint8_t green = 0, std::uint8_t blue = 0, std::uint8_t alpha = 255): m_red{red}, m_green{green}, m_blue{blue}, m_alpha{alpha} {}

  void print() {
    std::cout << "r=" << static_cast<int>(m_red) << " g=" << static_cast<int>(m_green) << " b=" << static_cast<int>(m_blue) << " a=" << static_cast<int>(m_alpha) << std::endl;
  }
};

int main()
{
  Ball def;
  def.print();

	Ball blue("blue");
	blue.print();

	Ball twenty(20.0);
	twenty.print();

	Ball blueTwenty("blue", 20.0);
	blueTwenty.print();

  RGBA teal(0, 127, 127);
	teal.print();

  return 0;
}
