#include "genetics.hpp"
#include "randomUInt.hpp"

void genome::mutation(int generation, int id) {
  //mutate a kid out of the elite
  std::vector<flare>::iterator previousFlare = genomeFlarePattern.begin();
  std::vector<flare>::iterator currentFlare = previousFlare+1;
  std::vector<flare>::iterator nextFlare = currentFlare+1;
  std::vector<flare> newFlarePattern;
  int maxRandTime = (2250 + genomeFlarePattern.size()/2) / genomeFlarePattern.size();

  //mutate each flare timing after first flare which is always 0
  for (unsigned int flareNum = 1; flareNum < genomeFlarePattern.size(); flareNum++) {
    int newTime;
    if (generation == 1)
      newTime = previousFlare->time + randomUInt(maxRandTime) + 1;
    else
      newTime = currentFlare->time + (randomUInt(1)*2 - 1) * randomUInt(maxRandTime / generation);

    //prevent flares from swapping ordering(if the flares want to swap then average the time distance between the two and set both to that average)
    if (newTime <= previousFlare->time)
      newTime = previousFlare->time;

    //replace flare in flarepattern and iterate flare indices
    currentFlare->time = newTime;
    previousFlare++;
    currentFlare++;
    nextFlare++;
  }

  fitness = 0;
  genomeID = id;
}
