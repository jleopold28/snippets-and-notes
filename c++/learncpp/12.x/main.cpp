#include <vector>
#include <iostream>

class Point {
private:
	int m_x = 0, m_y = 0, m_z = 0;

public:
	Point(int x, int y, int z): m_x{x}, m_y{y}, m_z{z} {}

	friend std::ostream& operator<<(std::ostream &out, const Point &point) {
		out << "Point(" << point.m_x << ", " << point.m_y << ", " << point.m_z << ")";
		return out;
	}
};

class Shape {
public:
  virtual std::ostream& print(std::ostream &out) const = 0;

  friend std::ostream& operator<<(std::ostream &out, const Shape &shape) {
    return shape.print(out);
  }

  virtual ~Shape() {}
};

class Triangle: public Shape {
private:
  Point m_p1, m_p2, m_p3;

public:
  Triangle(const Point &p1, const Point &p2, const Point &p3): m_p1{p1}, m_p2{p2}, m_p3{p3} {}

  virtual std::ostream& print(std::ostream &out) const override {
    out << "Triangle(" << m_p1 << ", " << m_p2 << ", " << m_p3 << ')';
    return out;
  }
};

class Circle: public Shape {
private:
  Point m_center;
  int m_radius;

public:
  Circle(const Point &center, int radius): m_center{center}, m_radius{radius} {}

  virtual std::ostream& print(std::ostream &out) const override {
    out << "Circle(" << m_center << ", radius " << m_radius << ')';
    return out;
  }

  int getRadius() { return m_radius; }
};

int getLargestRadius(std::vector<Shape*> &v) {
  int max = 0;

  for (auto shape: v) {
    Circle *c = dynamic_cast<Circle*>(shape);
    if (!c)
      continue;
    if (c->getRadius() > max)
      max = c->getRadius();
  }

  return max;
}

int main() {
  Circle c(Point(1, 2, 3), 7);
  std::cout << c << std::endl;

  Triangle t(Point(1, 2, 3), Point(4, 5, 6), Point(7, 8, 9));
  std::cout << t << std::endl;

  std::vector<Shape*> v;
	v.push_back(new Circle(Point(1, 2, 3), 7));
	v.push_back(new Triangle(Point(1, 2, 3), Point(4, 5, 6), Point(7, 8, 9)));
	v.push_back(new Circle(Point(4, 5, 6), 3));

	for (auto shape: v)
    std::cout << *shape << std::endl;

  std::cout << "The largest radius is: " << getLargestRadius(v) << '\n'; // write this function

	for (auto shape: v)
    delete shape;

  return 0;
}
