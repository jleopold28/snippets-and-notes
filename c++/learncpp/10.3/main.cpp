#include <string>
#include <iostream>
#include <vector>

class Teacher {
private:
  std::string m_name;

public:
  Teacher(std::string name): m_name{name} {}

  std::string getName() { return m_name; }
};

class Department {
private:
  std::vector<Teacher*> m_teacher; // This dept holds only one teacher for simplicity, but it could hold many teachers

public:
  Department(Teacher *teacher = nullptr): m_teacher{teacher} {}

  void add(Teacher *teacher) {
    m_teacher.push_back(teacher);
  }

  friend std::ostream& operator<<(std::ostream &out, const Department &dept) {
    out << "Department: ";
    for (auto teacher: dept.m_teacher)
      out << teacher->getName() << ' ';
    out << std::endl;

    return out;
  }
};

int main() {
  // Create a teacher outside the scope of the Department
  auto *t1 = new Teacher("Bob"); // create a teacher
  auto *t2 = new Teacher("Frank");
  auto *t3 = new Teacher("Beth");

  {
    // Create a department and use the constructor parameter to pass
    // the teacher to it.
    Department dept; // create an empty Department
    dept.add(t1);
    dept.add(t2);
    dept.add(t3);

    std::cout << dept;
  } // dept goes out of scope here and is destroyed

  std::cout << t1->getName() << " still exists!" << std::endl;
  std::cout << t2->getName() << " still exists!" << std::endl;
  std::cout << t3->getName() << " still exists!" << std::endl;

  delete t1;
  delete t2;
  delete t3;

  return 0;
}
