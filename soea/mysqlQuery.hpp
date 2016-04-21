#pragma once

enum matrixStatus {
  NONE,
  STARTED,
  FINISHED,
  ERROR
};

matrixStatus getMatrixStatus(std::string name);
double getMatrixResult(std::string name);
std::string getMatrixPattern(int id, std::string flarePatternName);
