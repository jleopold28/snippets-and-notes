#pragma once

#include <string>
#include <vector>
#include "genetics.hpp"

//First flare must have time = 0
std::string pattern2string(std::vector<flare> pattern, std::vector<std::string> dispensers);
std::vector<flare> string2pattern(std::string pattern, std::vector<std::string> *dispensers, std::vector<std::string> *flareNames);
void readDispensers(const char* xmlFile, std::vector<std::string> &dispensers, std::vector<std::string> &flareNames);
