#include <iostream>
#include <string>
#include <utility>
#include <sstream>
#include <vector>
#include <iomanip>
#include <pugixml.hpp>
#include "pattern2string.hpp"
#include "mysqlQuery.hpp"

//First flare must have time = 0
std::string pattern2string(std::vector<flare> pattern, std::vector<std::string> dispensers) {
  std::stringstream str;
  str << std::setfill('0');
  int lastTime = -1, lastDispenser = dispensers.size();

  //First sort by dispenser
  for (unsigned int i=0; i<pattern.size(); i++) {
    if (pattern[i].dispenser > (int)dispensers.size()) {
      std::cerr << "Error in pattern2string: Dispenser " << pattern[i].dispenser << " in flare " << i << " is out of range" << std::endl;
      return "";
    }
    unsigned int j = i+1;
    while (j < pattern.size() && pattern[j].time == pattern[i].time)
      j++;
    j--;
    if (i == j)
      continue;
    for (; i<j; i++) {
      for (unsigned int k=i+1; k<=j; k++) {
        if (pattern[k].dispenser == pattern[i].dispenser)
          return "Pattern Fail: Two flares coming from the same dispenser at the same time\n";
        if (pattern[k].dispenser < pattern[i].dispenser) {
          std::swap(pattern[k].dispenser, pattern[i].dispenser);
          std::swap(pattern[k].type, pattern[i].type);
        }
      }
    }
  }

  for (flare fl : pattern) {
//     std::cout << "Flare " << fl.type << " " << fl.time << " " << fl.dispenser << std::endl;
    if (fl.time != lastTime) {
      for (lastDispenser++; lastDispenser<(int)dispensers.size(); lastDispenser++)
        str << "|" << dispensers[lastDispenser] << ":NULL";
      if (lastTime >= 0)
        str << std::endl;
      str << "Time:" << std::setw(4) << fl.time;
      lastDispenser=-1;
      lastTime = fl.time;
    }
    for (lastDispenser++; lastDispenser<fl.dispenser; lastDispenser++)
        str << "|" << dispensers[lastDispenser] << ":NULL";
    str << "|" << dispensers[lastDispenser] << ":" << fl.type;
  }
  for (lastDispenser++; lastDispenser<(int)dispensers.size(); lastDispenser++)
    str << "|" << dispensers[lastDispenser] << ":NULL";
  str << std::endl;

  return str.str();
}

std::vector<flare> string2pattern(std::string pattern, std::vector<std::string> *dispensers, std::vector<std::string> *flareNames) {
  std::stringstream str(pattern);
  std::vector<flare> out;
  if (dispensers->size() > 0)
    dispensers = NULL;          //If dispensers has been initialized, then don't initialize it again
  //Read one line at a time
  while (!str.eof()) {
    std::string line;
    std::getline(str, line);
    std::stringstream linestr(line);
    std::string name;
    std::getline(linestr, name, ':');   //Just ignore the "Time:" part
    int time;
    linestr >> time;
    char discard;
    if (!linestr.eof())
      linestr >> discard;       //Ignore the '|' delimiter if there is one
    int dispenser = 0;
    while (!linestr.eof()) {
      std::getline(linestr, name, ':');
      if (dispensers)
        dispensers->push_back(name);
      std::getline(linestr, name, '|');
      if (name != "NULL") {
        out.push_back(flare(name, dispenser, time));
        if (flareNames)
          flareNames->push_back(name);
      }
      dispenser++;
    }
    dispensers = NULL;
  }
  return out;
}

void readDispensers(const char* xmlFile, std::vector<std::string> &dispensers, std::vector<std::string> &flareNames) {
  pugi::xml_document doc;
  pugi::xml_parse_result result = doc.load_file(xmlFile);
  pugi::xml_node flarePatternsNode = doc.child("TestMatrix").child("Dimensions").child("FlarePatternsDim");

  //xml file load properly check
  if (!result) {
    std::cerr << "XML [" << xmlFile << "] parsed with errors." << std::endl;
    std::cerr << "Error description: " << result.description() << std::endl;
    std::cerr << "Error offset: " << result.offset << " (error at [..." << (xmlFile + result.offset) << std::endl;
  }

  //process flare patterns
  if (flarePatternsNode.child("FlarePatternCfg")) {
    for (pugi::xml_node flarePattern: flarePatternsNode.children()) {
      if (flarePattern.child("FlarePattern")) {
        std::string pattern(flarePattern.child_value("FlarePattern"));
        string2pattern(pattern, &dispensers, &flareNames);
      } else
        std::cerr << "Flare Pattern value (FlarePattern) does not exist in " << xmlFile << std::endl;
    }
  }
  else
    std::cerr << "No flare patterns exist in " << xmlFile << std::endl;
}

void genome::setFromDatabase(std::string flarePatternName) {
  std::string pattern = getMatrixPattern(genomeID, flarePatternName);
  genomeFlarePattern = string2pattern(pattern, NULL, NULL);
}
