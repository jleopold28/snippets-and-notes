// I cannot debug this one and the suggested solution at learncpp is wrong, so leaving all of this "as is"

#include <iostream>
#include "Point3d.hpp"
#include "Vector3d.hpp"

int main()
{
	Point3d p(1.0, 2.0, 3.0);
	Vector3d v(2.0, 2.0, -3.0);

	p.print();
	p.moveByVector(v);
	p.print();

	return 0;
}
