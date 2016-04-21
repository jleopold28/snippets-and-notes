#include <iostream>
#include <string>
#include <pugixml.hpp>
#include "tmtXmlProcess.hpp"
#include "submitMatrix.hpp"

#ifdef USE_FAKE_WRAPPER
#define DIMENSION "DummyDimension"
#define CONFIG "DummyConfig"
#define NAME "DummyString"
#define PATTERN "bar"
#else
#define DIMENSION "FlarePatternsDim"
#define CONFIG "FlarePatternCfg"
#define NAME "PatternName"
#define PATTERN "FlarePattern"
#endif

bool tmtXmlProcess(const char* xmlFile, std::string newFlarePattern, std::string flarePatternName, int genomeID) {
  pugi::xml_document doc;
  pugi::xml_parse_result result = doc.load_file(xmlFile);
  pugi::xml_node flarePatternsNode = doc.child("TestMatrix").child("Dimensions").child(DIMENSION);
  if (!flarePatternsNode) {
    std::cerr << "Could not find the dimension" << std::endl;
    return false;
  }

  //xml file load properly check
  if (!result) {
    std::cerr << "XML [" << xmlFile << "] parsed with errors." << std::endl;
    std::cerr << "Error description: " << result.description() << std::endl;
    std::cerr << "Error offset: " << result.offset << " (error at [..." << (xmlFile + result.offset) << std::endl;
    return false;
  }

  //rename matrix name
  if (doc.child("TestMatrix")) {
    std::string matrixName = "SOEA_" + std::to_string(genomeID) + "_" + flarePatternName;
    doc.child("TestMatrix").child("Name").last_child().set_value(matrixName.c_str());
  }
  else {
    std::cerr << "No matrix name (Name) exists in " << xmlFile << std::endl;
    return false;
  }

  //process flare patterns
  if (flarePatternsNode.child(CONFIG)) {
    for (pugi::xml_node flarePattern: flarePatternsNode.children())
    {
      //rename flare pattern
      if (flarePattern.child(NAME)) {
        std::string currentPatternName = "Genome_" + std::to_string(genomeID) + "_" + flarePatternName;
        flarePattern.child(NAME).last_child().set_value(currentPatternName.c_str());
      }
      else {
        std::cerr << "Flare Pattern Name (PatternName) does not exist in " << xmlFile << std::endl;
        return false;
      }
      //insert flare pattern
      if (flarePattern.child(PATTERN))
        flarePattern.child(PATTERN).last_child().set_value(newFlarePattern.c_str());
#ifndef USE_FAKE_WRAPPER
      else {
        std::cerr << "Flare Pattern value (FlarePattern) does not exist in " << xmlFile << std::endl;
        return false;
      }
#endif
    }
  }
  else {
    std::cerr << "No flare patterns exist in " << xmlFile << std::endl;
    return false;
  }

  //save xml to new file
  std::string newXmlFile = "/tmp/SOEA_" + std::to_string(genomeID) + "_" + flarePatternName + ".xml";
  bool saveResult = doc.save_file(newXmlFile.c_str(), " ");
  if (!saveResult) {
    std::cerr << "Error saving " << newXmlFile << " after parsing " << xmlFile << std::endl;
    return false;
  }

  //submit to runmanager if everything ok thus far
  submitMatrix(newXmlFile.c_str());

  return true;
}
