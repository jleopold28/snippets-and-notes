#include <iostream>
#include <string>

enum class MonsterType {
  OGRE,
  DRAGON,
  ORC,
  GIANT_SPIDER,
  SLIME
};

struct Monster {
  MonsterType type;
  std::string name;
  int hp;
};

std::string typeToString(MonsterType type) {
  if (type == MonsterType::OGRE) {
    return "Ogre";
  }
  else if (type == MonsterType::DRAGON) {
    return "Dragon";
  }
  else if (type == MonsterType::ORC) {
    return "Orc";
  }
  else if (type == MonsterType::GIANT_SPIDER) {
    return "Giant Spider";
  }
  else if (type == MonsterType::SLIME) {
    return "Slime";
  }
  return "Unknown";
}

void printMonster(Monster monster) {
  std::cout << monster.name << std::endl;
  std::cout << "HP: " << monster.hp << std::endl;
  std::cout << "Type: " << typeToString(monster.type) << std::endl;
}

int main() {
  Monster shrek = {MonsterType::OGRE, "Shrek", 100};
  Monster metal = {MonsterType::SLIME, "Metal", 4};

  printMonster(shrek);
  printMonster(metal);

  return 0;
}
