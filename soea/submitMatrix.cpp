#include <iostream>
#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <signal.h>

//Returns true if something failed
bool submitMatrix(const char *fileName) {
  std::string command = "tmt-commandline-client --server tmtwratp --submit-no-register ";
  command += fileName;
  command += " 2>&1";
  FILE *stream = popen(command.c_str(), "r");
  const int MAX_BUFFER = 2048;
  char buffer[MAX_BUFFER];
  if (!fgets(buffer, MAX_BUFFER, stream)) {
    std::cerr << "submitMatrix: there was a problem running the command" << std::endl;
    return true;
  }
  if (strstr(buffer, "QUEUED") || strstr(buffer, "RUNNING")) {
    pclose(stream);
    return false;
  }
  if (strstr(buffer, "ERRORED"))
    std::cerr << "submitMatrix: there was an error from the runmanager" << std::endl;
  pclose(stream);
  
  return true;
}
