#include <iostream>
#include <cmath>

class Point2d {
private:
  double m_x, m_y;

public:
  Point2d(double x = 0.0, double y = 0.0): m_x{x}, m_y{y} {}

  void print() {
    std::cout << '(' << m_x << ", " << m_y << ')' << std::endl;
  }

  friend double distanceFrom(Point2d point, Point2d other_point);
};

double distanceFrom(Point2d point, Point2d other_point) {
  return sqrt(pow(point.m_x - other_point.m_x, 2) + pow(point.m_y - other_point.m_y, 2));
}

int main()
{
    Point2d first;
    Point2d second(3.0, 4.0);
    first.print();
    second.print();
    std::cout << "Distance between two points: " << distanceFrom(first, second) << '\n';

    return 0;
}
