#ifndef GENETICS_HPP
#define GENETICS_HPP

#include <vector>
#include <string>

class genome;

class flare {
  friend class genome;
  friend void initGenePool(int generation, int numGenomes, std::string flarePatternName, std::vector<genome> &genePool, std::vector<std::string> dispensers, std::vector<std::string> flareTypes, std::string xmlFile);
  friend std::string pattern2string(std::vector<flare> pattern, std::vector<std::string> dispensers);

  flare() {}

  std::string type;
  int dispenser, time;

public:
  flare(std::string type, int dispenser, int time) : type(type), dispenser(dispenser), time(time) {}
};

class genome {
  friend void initGenePool(int generation, int numGenomes, std::string flarePatternName, std::vector<genome> &genePool, std::vector<std::string> dispensers, std::vector<std::string> flareTypes, std::string xmlFile);
  friend void fitness(int &generation, unsigned int numElites, unsigned int numGenomes, std::string flarePatternName, std::vector<genome> &genePool, std::vector<std::string> dispensers, std::string xmlFile);

  void mutation(int generation, int id);
  //unsure where crossover belongs
  void crossover(int generation, int numClones, std::vector<genome> &genePool);
  void setFromDatabase(std::string flarePatternName);

  double fitness;
  int genomeID;
  std::vector<flare> genomeFlarePattern;

public:
  std::string to_string(std::vector<std::string> dispensers) {return pattern2string(genomeFlarePattern, dispensers);};
};

#endif
