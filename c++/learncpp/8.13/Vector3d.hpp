#pragma once

#include "Point3d.hpp"

class Vector3d {
private:
	double m_x, m_y, m_z;

public:
	Vector3d(double x = 0.0, double y = 0.0, double z = 0.0): m_x{x}, m_y{y}, m_z{z} {}

  void print();
  friend void Point3d::moveByVector(Vector3d &v);
};
