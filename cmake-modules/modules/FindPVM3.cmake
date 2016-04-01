# Created from scratch
#
# - Try to find PVM3
# Once done this will define
#
#  PVM3_FOUND			- system has PVM3
#  PVM3_INCLUDE_DIR		- the PVM3 include directory
#  PVM3_LIBRARY_DIR		- where the libraries are
#  PVM3_LIBRARY			- link library to use normal PVM3
#  PVM3_SHAREMEM_LIBRARY	- link library to use shared memory PVM3

IF(PVM3_INCLUDE_DIR)
  #already in cache
  SET(PVM3_FIND_QUIETLY TRUE)
ENDIF(PVM3_INCLUDE_DIR)

IF(WIN32) #this likely does not work
  FIND_PATH(PVM3_INCLUDE_DIR pvm3.h
            PATHS c:/pvm3/include)
  FIND_PATH(PVM3_SRC_DIR lpvm.h
            PATHS c:/pvm3/src)
  FIND_LIBRARY(PVM3_LIBRARY
               NAMES pvm3
               PATHS c:/pvm3/lib/WIN32 c:/pvm3/lib/WIN64)
  FIND_LIBRARY(PVM3_SHAREMEM_LIBRARY
               NAMES pvm3shmd
               PATHS c:/pvm3/lib/WIN32 c:/pvm3/lib/WIN64)
ELSE(WIN32)
  FIND_PATH(PVM3_INCLUDE_DIR pvm3.h
            PATHS /usr/share /usr/local/share
            PATH_SUFFIXES pvm3/include/ PVM3/include/)
  FIND_PATH(PVM3_SRC_DIR lpvm.h
            PATHS /usr/share /usr/local/share
            PATH_SUFFIXES pvm3/src/ PVM3/src/)
  FIND_LIBRARY(PVM3_LIBRARY
               NAMES pvm3
               PATHS /usr/share/pvm3/lib/LINUX64 /usr/share/pvm3/lib/LINUX32 /usr/local/share/pvm3/lib/LINUX64 /usr/local/share/pvm3/lib/LINUX32)
  FIND_LIBRARY(PVM3_SHAREMEM_LIBRARY
               NAMES pvm3shmd
               PATHS /usr/share/pvm3/lib/LINUX64 /usr/share/pvm3/lib/LINUX32 /usr/local/share/pvm3/lib/LINUX64 /usr/local/share/pvm3/lib/LINUX32)
ENDIF(WIN32)

GET_FILENAME_COMPONENT(PVM3_LIBRARY_DIR ${PVM3_LIBRARY} PATH)

IF(PVM3_INCLUDE_DIR AND PVM3_LIBRARY AND PVM3_SRC_DIR AND PVM3_SHAREMEM_LIBRARY)
  SET(PVM3_FOUND TRUE)
  SET(PVM3_LIBRARY_DIR ${PVM3_LIBRARY})
ELSE(PVM3_INCLUDE_DIR AND PVM3_LIBRARY AND PVM3_SRC_DIR AND PVM3_SHAREMEM_LIBRARY)
  SET(PVM3_FOUND FALSE)
  SET(PVM3_LIBRARY_DIR)
ENDIF(PVM3_INCLUDE_DIR AND PVM3_LIBRARY AND PVM3_SRC_DIR AND PVM3_SHAREMEM_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set PVM3_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PVM3 DEFAULT_MSG PVM3_LIBRARY PVM3_INCLUDE_DIR PVM3_SRC_DIR PVM3_SHAREMEM_LIBRARY)

MARK_AS_ADVANCED(
  PVM3_LIBRARY
  PVM3_INCLUDE_DIR
  PVM3_SRC_DIR
  PVM3_SHAREMEM_LIBRARY
  PVM3_LIBRARY_DIR)
