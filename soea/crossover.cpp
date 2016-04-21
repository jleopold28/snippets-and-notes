#include "randomUInt.hpp"
#include "genetics.hpp"

void genome::crossover(int generation, int numClones, std::vector<genome> &genePool) {
  std::vector<genome>::iterator eliteOneClone = genePool.begin();

  //loop through all clones of the first elite
  for (int cloneOne = 0; cloneOne < numClones; cloneOne++) {
    //loop through the corresponding clone of the other elites
    for (int cloneTwo = 1; cloneTwo < numClones; cloneTwo++) {
      int cloneTwoIndex = cloneTwo * numClones + cloneOne;
      //spawn two children and replace each of the original elites
      for (unsigned int flareNum = 1; flareNum < genePool[cloneOne].genomeFlarePattern.size(); flareNum++) {
        //50% chance to replace flare time with other elite's corresponding flare time
        int seedOne = randomUInt(1);
        if (seedOne == 1)
          genePool[cloneOne].genomeFlarePattern[flareNum].time = genePool[cloneTwoIndex].genomeFlarePattern[flareNum].time;
        //prevent flares from swapping ordering(if the flares want to swap then average the time distance between the two and set both to that average)
        if (genePool[cloneOne].genomeFlarePattern[flareNum].time < genePool[cloneOne].genomeFlarePattern[flareNum - 1].time)
          genePool[cloneOne].genomeFlarePattern[flareNum].time = genePool[cloneOne].genomeFlarePattern[flareNum - 1].time;
        int seedTwo = randomUInt(1);
        if (seedTwo == 1)
          genePool[cloneTwoIndex].genomeFlarePattern[flareNum].time = genePool[cloneOne].genomeFlarePattern[flareNum].time;
        if (genePool[cloneTwoIndex].genomeFlarePattern[flareNum].time < genePool[cloneTwoIndex].genomeFlarePattern[flareNum - 1].time)
          genePool[cloneTwoIndex].genomeFlarePattern[flareNum].time = genePool[cloneTwoIndex].genomeFlarePattern[flareNum - 1].time;
      }
      genePool[cloneOne].fitness = 0;
      genePool[cloneTwoIndex].fitness = 0;
      genePool[cloneOne].genomeID += (1 + generation) * genePool.size();
      genePool[cloneTwoIndex].genomeID += (1 + generation) * genePool.size();
    }
    eliteOneClone++;
  }
}
