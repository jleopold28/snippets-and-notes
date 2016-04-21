//an executable for unit tests
#include <iostream>
#include "genetics.hpp"
#include "tmtXmlProcess.hpp"
#include "mysqlQuery.hpp"
#include "randomUInt.hpp"
#include "pattern2string.hpp"

int main(int argc, char **argv) {
  //default values
  int generation = -1, numGenomes = 10, elitePercentage = 10;
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
    }
  }

  //check values and calculate number of retained elites
  if ((numGenomes < 10) || ((numGenomes % elitePercentage) != 0) ) {
    std::cerr << "Invalid number of genomes, flares, or dispensers." << std::endl;
    return 1;
  }
  int numElites = numGenomes * elitePercentage * 0.01;

  //map dispenser int to string name
  std::vector<std::string> dispensers;
  std::vector<std::string> flareTypes;
#ifdef USE_FAKE_WRAPPER
  readDispensers("utilities/test.xml", dispensers, flareTypes);
#else
  readDispensers(xmlFile.c_str(), dispensers, flareTypes);
#endif

  //initgenepool unit tests
  if (generation < 1)
    initGenePool(generation, numGenomes, flarePatternName, genePool, dispensers, flareTypes, xmlFile);

  //fitness unit tests
  if (generation < 1)
    fitness(generation, 1, numGenomes, flarePatternName, genePool, dispensers, xmlFile);
  else
    fitness(generation, numElites, numGenomes, flarePatternName, genePool, dispensers, xmlFile);

  //randomUInt unit tests
  int rng = randomUInt(1);
  if (rng < 0 || rng > 1) {
    std::cerr << "RNG is broken." << std::endl;
    return 1;
  }

  //crossover unit tests

  return 0;
}
