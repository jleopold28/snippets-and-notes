#include <string>
#include <iostream>
#include <random>

class Monster {
public:
  enum MonsterType {
    Dragon,
    Goblin,
    Ogre,
    Orc,
    Skeleton,
    Troll,
    Vampire,
    Zombie,
    MAX_MONSTER_TYPES
  };

private:
  MonsterType m_type;
  std::string m_name, m_roar;
  int m_hp;

public:
  Monster(MonsterType type, std::string name, std::string roar, int hp): m_type{type}, m_name{name}, m_roar{roar}, m_hp{hp} {}

  std::string typeToString() {
    switch (m_type) {
      case Dragon: return "Dragon";
      case Goblin: return "Goblin";
      case Ogre: return "Ogre";
      case Orc: return "Orc";
      case Skeleton: return "Skeleton";
      case Troll: return "Troll";
      case Vampire: return "Vampire";
      case Zombie: return "Vampire";
      default: return "Error!";
    }
  }

  void print() {
    std::cout << "Name: " << m_name << std::endl;
    std::cout << "Type: " << typeToString() << std::endl;
    std::cout << "HP: " << m_hp << std::endl;
    std::cout << "Roar: " << m_roar << std::endl;
  }
};

class MonsterGenerator {
public:
  static int rdmNum(int min, int max) {
    static std::random_device rd;
    std::mt19937 mersenne(rd());
    return (mersenne() % max) + min;
  }

  static Monster generateMonster() {
    auto type = static_cast<Monster::MonsterType>(rdmNum(0, Monster::MAX_MONSTER_TYPES - 1));
    static std::string names[6]{"Blarg", "Moog", "Pksh", "Tyrn", "Mort", "Hans"};
		static std::string roars[6]{"*ROAR*", "*peep*", "*squeal*", "*whine*", "*hum*", "*burp*"};

    return Monster(type, names[rdmNum(0, 5)], roars[rdmNum(0, 5)], rdmNum(1, 100));
  }
};

int main() {
  auto m = MonsterGenerator::generateMonster();
	m.print();

  return 0;
}
