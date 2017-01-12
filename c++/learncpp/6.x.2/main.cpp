#include <iostream>
#include <string>

struct Student {
  std::string name;
  short grade;
};

int main() {
  std::cout << "How many students do you wish to input?" << std::endl;
  short num_students;
  std::cin >> num_students;

  Student *students = new Student[num_students];

  for (auto i = 0; i < num_students; ++i) {
    std::cout << "Please enter student name." << std::endl;
    std::cin >> students[i].name;
    std::cout << "Please enter student grade." << std::endl;
    std::cin >> students[i].grade;
  }

  for (auto i = 1; i < num_students; ++i) {
    auto swap = false;

    for (auto j = 1; j < num_students; ++j)
      if (students[j-1].grade > students[j].grade) {
        std::swap(students[j-1], students[j]);
        swap = true;
      }

    if (!swap) {
      std::cout << "Terminated on iteration " << i << std::endl;
      break;
    }
  }

  for (auto i = 0; i < num_students; ++i)
    std::cout << students[i].name << ": " << students[i].grade << std::endl;

  delete[] students;
  students = nullptr;

  return 0;
}
