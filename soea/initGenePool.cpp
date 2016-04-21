#include "genetics.hpp"
#include "pattern2string.hpp"
#include "tmtXmlProcess.hpp"
#include "randomUInt.hpp"

void initGenePool(int generation, int numGenomes, std::string flarePatternName, std::vector<genome> &genePool, std::vector<std::string> dispensers, std::vector<std::string> flareTypes, std::string xmlFile) {
  //create genomes
  for (int genomeNum = 0; genomeNum < numGenomes; genomeNum++) {
    genome currentGenome;
    if (generation == 0)
      currentGenome = genePool[genomeNum];
    currentGenome.fitness = 0;
    currentGenome.genomeID = genomeNum + ((1 + generation) * numGenomes);
    std::vector<std::string> tmpFlareTypes = flareTypes;
    //create flare pattern(do math and specify all possibilities instead of random?)
    for (unsigned int flareNum = 0; flareNum < flareTypes.size(); flareNum++) {
      //optimize flare order
      if (generation == -1) {
        flare currentFlare;
        currentFlare.dispenser = flareNum % dispensers.size();
        currentFlare.time = flareNum * 2250 / flareTypes.size() + 0.5;
        int seed = randomUInt(tmpFlareTypes.size() - 1);
        currentFlare.type = tmpFlareTypes[seed];
        tmpFlareTypes.erase(tmpFlareTypes.begin() + seed);
        currentGenome.genomeFlarePattern.push_back(currentFlare);
      }
      //optimize dispenser configuration
      else if (generation == 0) {
        int previousDispenser = currentGenome.genomeFlarePattern[flareNum].dispenser;
        while (previousDispenser == currentGenome.genomeFlarePattern[flareNum].dispenser)
          currentGenome.genomeFlarePattern[flareNum].dispenser = randomUInt(dispensers.size() - 1);
      }
    }

    //convert flarepattern vector to string and then submit genome to tmt
    std::string stringFlarePattern = pattern2string(currentGenome.genomeFlarePattern, dispensers);
    tmtXmlProcess(xmlFile.c_str(), stringFlarePattern, flarePatternName, currentGenome.genomeID);

    //add genome to genepool
    if (generation == -1)
      genePool.push_back(currentGenome);
    else if (generation == 0)
      genePool[genomeNum] = currentGenome;
  }
}
