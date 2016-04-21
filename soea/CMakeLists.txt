#!/usr/bin/cmake (el7/gentoo/ub14) or /usr/bin/cmake28 (el6)

#header
cmake_minimum_required(VERSION 2.8.11)
project(SOEA CXX)

#cxx
if(NOT RELEASE)
  add_definitions(-DUSE_FAKE_WRAPPER)
  set(CMAKE_CXX_FLAGS "-g -Wall -std=c++11")
else(NOT RELEASE)
  set(CMAKE_CXX_FLAGS "-O3 -fPIC -funroll-loops -std=c++11")
endif(NOT RELEASE)

if(NOT EL6)
  set(CMAKE_CXX_COMPILER /usr/bin/g++)
else(NOT EL6)
  set(CMAKE_CXX_COMPILER /usr/bin/g++48)
endif(NOT EL6)

#pugixml
find_path(PUGIXML_INCLUDE_DIR
  NAMES pugixml.hpp
  PATHS /usr/include)
find_library(PUGIXML_LIBRARY
  NAMES pugixml
  PATHS /usr/lib64)

INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PUGIXML DEFAULT_MSG PUGIXML_LIBRARY PUGIXML_INCLUDE_DIR)

#sql++
find_path(SQL++_INCLUDE_DIR
          NAMES mysql++.h
          PATHS /usr/include/mysql++)
find_library(SQL++_LIBRARY
             NAMES mysqlpp
             PATHS /usr/lib64)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SQL++ DEFAULT_MSG SQL++_LIBRARY SQL++_INCLUDE_DIR)

#mariadb
find_path(MARIADB_INCLUDE_DIR
          NAMES mysql_version.h
          PATHS /usr/include/mysql)
find_library(MARIADB_CLIENT_LIBRARY
             NAMES mysqlclient mariadbclient
             PATHS /usr/lib64/mysql)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(MARIADB DEFAULT_MSG MARIADB_CLIENT_LIBRARY MARIADB_INCLUDE_DIR)

#includes
include_directories(
  ${PUGIXML_INCLUDE_DIR}
  ${SQL++_INCLUDE_DIR}
  ${MARIADB_INCLUDE_DIR})

#compile soea
add_executable(soea
  soea.cpp
  mutation.cpp
  initGenePool.cpp
  fitness.cpp
  crossover.cpp
  tmtXmlProcess.cpp
  mysqlQuery.cpp
  submitMatrix.cpp
  pattern2string.cpp
  randomUInt.cpp)

#link soea
target_link_libraries(soea
  ${PUGIXML_LIBRARY}
  ${SQL++_LIBRARY}
  ${MARIADB_CLIENT_LIBRARY})

if(NOT RELEASE)
  #compile test_soea
  add_executable(test_soea
    test_soea.cpp
    mutation.cpp
    initGenePool.cpp
    fitness.cpp
    crossover.cpp
    tmtXmlProcess.cpp
    mysqlQuery.cpp
    submitMatrix.cpp
    pattern2string.cpp
    randomUInt.cpp)

  #link test_soea
  target_link_libraries(test_soea
    ${PUGIXML_LIBRARY}
    ${SQL++_LIBRARY}
    ${MARIADB_CLIENT_LIBRARY})
endif(NOT RELEASE)
