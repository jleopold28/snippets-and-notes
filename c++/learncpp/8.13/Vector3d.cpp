#include <iostream>
#include "Vector3d.hpp"

void Vector3d::print() {
  std::cout << "Vector(" << m_x << ", " << m_y << ", " << m_z << ')' << std::endl;
}
