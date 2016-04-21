#include <iostream>
#include "genetics.hpp"
#include "pattern2string.hpp"

int main(int argc, char **argv) {
  //default values
  unsigned int numGenomes = 100, elitePercentage = 10, startGenOne = 0;
  int generation = -1;
#ifdef USE_FAKE_WRAPPER
  std::string flarePatternName = "foobarbaz", xmlFile = "utilities/testMatrix.xml";
#else
  std::string flarePatternName = "foobarbaz", xmlFile = "template.xml";
#endif
  std::vector<genome> genePool;

  //command line arguments
  if (argc > 1) {
    for (int i = 1; i < argc; i++) {
      if (std::string(argv[i]) == "--help") {
        std::cout << "--help           prints this message" << std::endl;
        std::cout << "--genomes        specifies the number of genomes in a gene pool (>= 10 and divisible by 10)" << std::endl;
        std::cout << "--name           specifies the nickname of the flare pattern to be optimized" << std::endl;
        std::cout << "--eliteperc      specifies the percentage of the gene pool to retain as elites" << std::endl;
        std::cout << "--xml            specifies the tmt xml template to use for generating genome xml files for runmanager submission" << std::endl;
        std::cout << "--startgenone    assume the tmt xml template already has optimized flare and dispenser ordering (0 or 1; feature incomplete)" << std::endl;
        return 0;
      }
      if (std::string(argv[i]) == "--genomes")
        numGenomes = std::stoi(argv[++i]);
      if (std::string(argv[i]) == "--name")
        flarePatternName = argv[++i];
      if (std::string(argv[i]) == "--eliteperc")
        elitePercentage = std::stoi(argv[++i]);
      if (std::string(argv[i]) == "--xml")
        xmlFile = argv[++i];
      if (std::string(argv[i]) == "--startgenone")
        startGenOne = std::stoi(argv[++i]);
    }
  }

  //map dispenser int to string name(need to absorb into pattern2string)
  std::vector<std::string> dispensers;
  std::vector<std::string> flareTypes;
#ifdef USE_FAKE_WRAPPER
  readDispensers("utilities/test.xml", dispensers, flareTypes);
#else
  readDispensers(xmlFile.c_str(), dispensers, flareTypes);
#endif

  //check values and calculate number of retained elites
  if ((numGenomes < 10) || ((numGenomes % elitePercentage) != 0)) {
    std::cerr << "Invalid number of genomes, flares, or dispensers." << std::endl;
    return 1;
  }
  unsigned int numElites = numGenomes * elitePercentage * 0.01;

  if (startGenOne)
    generation = 0;
  else {
    initGenePool(generation, numGenomes, flarePatternName, genePool, dispensers, flareTypes, xmlFile);
    fitness(generation, 1, numGenomes, flarePatternName, genePool, dispensers, xmlFile);
    initGenePool(generation, numGenomes, flarePatternName, genePool, dispensers, flareTypes, xmlFile);
  }
  while (true)
    //is this call to fitness producing more than one elite for the gen one spawn?
    fitness(generation, numElites, numGenomes, flarePatternName, genePool, dispensers, xmlFile);

  return 0;
}
