#include <iostream>
#include <vector>
#include <unistd.h>
#include "genetics.hpp"
#include "mysqlQuery.hpp"
#include "tmtXmlProcess.hpp"

using namespace std;

void fitness(int &generation, unsigned int numElites, unsigned int numGenomes, string flarePatternName, vector<genome> &genePool, vector<string> dispensers, std::string xmlFile) {
  genome *elites = new genome [numElites];
  double *fitnesses = new double [numElites];
  double minFitness;
  unsigned int minFitnessIdx;
  for (unsigned int i = 0; i<genePool.size(); i++) {
    genome current = genePool[i];
    string matrixName = "SOEA_" + to_string(current.genomeID) + "_" + flarePatternName;
    matrixStatus status = getMatrixStatus(matrixName);
    if (status == NONE) {
      cerr << "Fitness Error: Matrix " << matrixName << " does not exist" << endl;
      return;
    }
    while (status == STARTED) {
      sleep(10);
      status = getMatrixStatus(matrixName);
    }
    if (status == ERROR || status == NONE) {
      cerr << "Fitness Error: Matrix " << matrixName << "had a problem" << endl;
      return;
    }
    double fitness = getMatrixResult(matrixName);
    if (i < numElites) {        //Fill up the elites until full
      elites[i] = current;
      fitnesses[i] = fitness;
      if (!i || minFitness > fitness) {
        minFitness = fitness;
        minFitnessIdx = i;
      }
      continue;
    }
    if (fitness <= minFitness)
      continue;         //If the genome is not an elite, then throw it away
    elites[minFitnessIdx] = current;
    fitnesses[minFitnessIdx] = fitness;
    minFitness = fitness;     //Make a dumb guess that is better than nothing
    for (unsigned int j=0; j<numElites; j++) {
      if (minFitness > fitnesses[j]) {
        minFitness = fitnesses[j];    //Correct the bad guess
        minFitnessIdx = j;
      }
    }
  }

  //Print out the worst of the elites
  cout << "Generation " << generation << " worst elite " << elites[minFitnessIdx].genomeID
       << " has fitness " << minFitness << endl;

  //Find the performance of the best gene
  minFitnessIdx = 0;    //Make a dumb guess that is better than nothing
  minFitness = fitnesses[0];
  for (unsigned int i=1; i<numElites; i++) {
    if (minFitness < fitnesses[i]) {
      minFitness = fitnesses[i];    //Correct the bad guess
      minFitnessIdx = i;
    }
  }
  //Print out the best of the elites
  cout << "Generation " << generation << " best elite " << elites[minFitnessIdx].genomeID
       << " has fitness " << minFitness << endl;

  if (minFitness > 0.99)
    exit(0);

  for (unsigned int i=0; i<numElites; i++)
    elites[i].setFromDatabase(flarePatternName);     //Re-read the elites from the database

  generation++; //That generation is done, now we start the next
  for (unsigned int i=0; i<genePool.size(); i++)
    genePool[i] = elites[i % numElites];    //Put the elites into the genePool
  for (unsigned int i=genePool.size(); i<numGenomes+numElites; i++)
    genePool.push_back(elites[i % numElites]);  //Accomodate the first two generations where the number of elites changes        
  if (generation < 1)
    return;
//  else if (generation == 7) {
//    crossover(generation, genePool.size() / numElites, genePool);
//    generation = 1;
//  }
//  else {
  for (unsigned int i=numElites; i<genePool.size(); i++)
    genePool[i].mutation(generation, (1 + generation) * numGenomes + i - numElites);
// }
  for (unsigned int i=numElites; i<genePool.size(); i++) {
    string stringFlarePattern = pattern2string(genePool[i].genomeFlarePattern, dispensers);
    tmtXmlProcess(xmlFile.c_str(), stringFlarePattern, flarePatternName, genePool[i].genomeID);
  }
}
