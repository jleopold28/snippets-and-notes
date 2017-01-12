#include <iostream>
#include <string>

void arraySort(std::string *array, short length)
{
	for (auto i = 0; i < length; ++i)
	{
		auto smallestIndex = i;

		for (auto j = i + 1; j < length; ++j)
			if (array[j] < array[smallestIndex])
				smallestIndex = j;

		std::swap(array[i], array[smallestIndex]);
	}
}

int main() {
  std::cout << "How many names do you want to enter?" << std::endl;
  short num_names;
  std::cin >> num_names;

  std::string *names = new std::string[num_names];

  for (auto i = 0; i < num_names; ++i) {
    std::cout << "Please enter name " << i+1 << std::endl;
    std::cin >> names[i];
  }

  arraySort(names, num_names);

  std::cout << "Sorted names:" << std::endl;
  for (auto i = 0; i < num_names; ++i)
    std::cout << names[i] << std::endl;

  delete[] names;
  names = nullptr;

  return 0;
}
