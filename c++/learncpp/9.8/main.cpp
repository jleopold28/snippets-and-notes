#include <string>
#include <vector>
#include <iostream>

struct StudentGrade {
  std::string name;
  char grade;
};

class GradeMap {
private:
  std::vector<StudentGrade> m_map;

public:
  GradeMap() {};

  char& operator[](const std::string &name) {
    for (auto &pair: m_map) {
      if (pair.name == name)
        return pair.grade;
    }

    StudentGrade temp{name, ' '};
    m_map.push_back(temp);
    return m_map.back().grade;
  }
};

int main()
{
	GradeMap grades;
	grades["Joe"] = 'A';
	grades["Frank"] = 'B';
	std::cout << "Joe has a grade of " << grades["Joe"] << std::endl;
	std::cout << "Frank has a grade of " << grades["Frank"] << std::endl;

	return 0;
}
