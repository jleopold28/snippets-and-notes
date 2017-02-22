#include <iostream>
#include <string>
#include <random>

static int rdmNum(int max) {
  static std::random_device rd;
  std::mt19937 mersenne(rd());
  return mersenne() % (max + 1);
}

class Creature {
protected:
  std::string m_name;
  char m_symbol;
  int m_hp, m_dmg, m_gold;

public:
  Creature(std::string name, char symbol, int hp, int dmg, int gold): m_name{name}, m_symbol{symbol}, m_hp{hp}, m_dmg{dmg}, m_gold{gold} {}

  friend std::ostream& operator<<(std::ostream &out, const Creature &creature) {
    out << "The " << creature.m_name << " has " << creature.m_symbol << " health and is carrying " << creature.m_gold << " gold.";
    return out;
  }

  std::string getName() { return m_name; }
  char getSymbol() { return m_symbol; }
  int getHP() { return m_hp; }
  int getDmg() { return m_dmg; }
  int getGold() { return m_gold; }

  void reduceHealth(int dmg) { m_hp -= dmg; }
  bool isDead() { return m_hp <= 0; }
  void addGold(int gold) { m_gold += gold; }
};

class Player: public Creature {
private:
  int m_level = 1;

public:
  Player(std::string name): Creature{name, '@', 10, 1, 0} {}

  int getLevel() { return m_level; }

  void levelUp() {
    ++m_level;
    ++m_dmg;
  }
  bool hasWon() { return m_level >= 20; }
};

class Monster: public Creature {
public:
  enum Type {
		DRAGON,
		ORC,
		SLIME,
		MAX_TYPES
	};

  struct MonsterData {
    std::string name;
		char symbol;
		int hp, dmg, gold;
  };

  Monster(Type type): Creature(monsterData[type].name, monsterData[type].symbol, monsterData[type].hp, monsterData[type].dmg, monsterData[type].gold) {}

  static MonsterData monsterData[MAX_TYPES];

  static Monster getRandomMonster() {
    return Monster(static_cast<Type>(rdmNum(MAX_TYPES - 1)));
  }
};

Monster::MonsterData Monster::monsterData[Monster::MAX_TYPES] {
	{ "dragon", 'D', 20, 4, 100 },
	{ "orc", 'o', 4, 2, 25 },
	{ "slime", 's', 1, 1, 10 }
};

void attackMonster(Player &player, Monster &monster) {
  if (player.isDead())
    return;

  std::cout << "You hit the " << monster.getName() << " for " << player.getDmg() << " damage." << std::endl;
  monster.reduceHealth(player.getDmg());

  if (monster.isDead()) {
    std::cout << "You killed the " << monster.getName() << ".\n";
		player.levelUp();
		std::cout << "You are now level " << player.getLevel() << " and found " << monster.getGold() << " gold." << std::endl;
		player.addGold(monster.getGold());
  }
}

void attackPlayer(Monster &monster, Player &player) {
  if (monster.isDead())
    return;

  std::cout << "The " << monster.getName() << " hit you for " << monster.getDmg() << " damage." << std::endl;
  player.reduceHealth(monster.getDmg());
}

void fightMonster(Player &player) {
  auto monster = Monster::getRandomMonster();
  std::cout << "You have encountered a " << monster.getName() << " (" << monster.getSymbol() << ")." << std::endl;

  while (!monster.isDead() && !player.isDead()) {
    std::cout << "(R)un or (F)ight: " << std::endl;
		char input;
		std::cin >> input;

		if (input == 'R' || input == 'r') {
			if (rdmNum(1) == 1) {
				std::cout << "You successfully fled." << std::endl;
				return;
			}
			else {
				std::cout << "You failed to flee." << std::endl;
				attackPlayer(monster, player);
				continue;
			}
		}
    else if (input == 'F' || input == 'f') {
			attackMonster(player, monster);
			attackPlayer(monster, player);
		}
  }
}

int main() {
  std::cout << "Enter your name: " << std::endl;
  std::string playerName;
  std::cin >> playerName;

  Player player(playerName);
  std::cout << "Welcome, " << player.getName() << std::endl;

  while (!player.isDead() && !player.hasWon())
    fightMonster(player);

  if (player.isDead())
    std::cout << "You died at level " << player.getLevel() << " and with " << player.getGold() << " gold." << std::endl;
  else
    std::cout << "You won the game with " << player.getGold() << " gold!" << std::endl;

	return 0;
}
