# Created from scratch
#
# - Try to find Sundials
# Once done this will define
#
#  SUNDIALS_FOUND		- system has Sundials
#  SUNDIALS_INCLUDE_DIR		- the Sundials include directory
#  SUNDIALS_LIBRARY_DIR		- where the libraries are
#  SUNDIALS_LIBRARIES		- aggregated Sundials libraries

IF(SUNDIALS_INCLUDE_DIR)
  #already in cache
  SET(SUNDIALS_FIND_QUIETLY TRUE)
ENDIF(SUNDIALS_INCLUDE_DIR)

#include directory for "include "dir/foo.h" specification for header files
FIND_PATH(SUNDIALS_INCLUDE_DIR
          NAMES sundials/sundials_config.h
          PATHS /usr/include)

#cannot combine these "finds" using component based find commands because of inconsistency between primary include header and library names

#aggregate include directories properly
FIND_PATH(SUNDIALS_SUNDIALS_INCLUDE_DIR sundials_config.h
          PATHS /usr/include
          PATH_SUFFIXES sundials/)
FIND_PATH(SUNDIALS_CVODE_INCLUDE_DIR cvode.h
          PATHS /usr/include
          PATH_SUFFIXES cvode/)
FIND_PATH(SUNDIALS_IDA_INCLUDE_DIR ida.h
          PATHS /usr/include
          PATH_SUFFIXES ida/)
FIND_PATH(SUNDIALS_KINSOL_INCLUDE_DIR kinsol.h
          PATHS /usr/include
          PATH_SUFFIXES kinsol/)
FIND_PATH(SUNDIALS_NVECTOR_INCLUDE_DIR nvector_serial.h
          PATHS /usr/include
          PATH_SUFFIXES nvector/)
SET(SUNDIALS_INCLUDE_DIRS ${SUNDIALS_SUNDIALS_INCLUDE_DIR} ${SUNDIALS_CVODE_INCLUDE_DIR} ${SUNDIALS_IDA_INCLUDE_DIR} ${SUNDIALS_KINSOL_INCLUDE_DIR} ${SUNDIALS_NVECTOR_INCLUDE_DIR})

#aggregate libraries properly
FIND_LIBRARY(SUNDIALS_CVODE_LIBRARY
             NAMES sundials_cvode
             PATHS /usr/lib64)
FIND_LIBRARY(SUNDIALS_IDA_LIBRARY
             NAMES sundials_ida
             PATHS /usr/lib64)
FIND_LIBRARY(SUNDIALS_KINSOL_LIBRARY
             NAMES sundials_kinsol
             PATHS /usr/lib64)
FIND_LIBRARY(SUNDIALS_NVECSERIAL_LIBRARY
             NAMES sundials_nvecserial
             PATHS /usr/lib64)
SET(SUNDIALS_LIBRARIES ${SUNDIALS_CVODE_LIBRARY} ${SUNDIALS_IDA_LIBRARY} ${SUNDIALS_KINSOL_LIBRARY} ${SUNDIALS_NVECSERIAL_LIBRARY})

GET_FILENAME_COMPONENT(SUNDIALS_LIBRARY_DIR ${SUNDIALS_CVODE_LIBRARY} PATH)

IF(SUNDIALS_INCLUDE_DIR AND SUNDIALS_LIBRARIES)
  SET(SUNDIALS_FOUND TRUE)
  SET(SUNDIALS_LIBRARY_DIR ${SUNDIALS_LIBRARIES})
ELSE(SUNDIALS_INCLUDE_DIR AND SUNDIALS_LIBRARIES)
  SET(SUNDIALS_FOUND FALSE)
  SET(SUNDIALS_LIBRARY_DIR)
ENDIF(SUNDIALS_INCLUDE_DIR AND SUNDIALS_LIBRARIES)

# handle the QUIETLY and REQUIRED arguments and set SUNDIALS_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Sundials DEFAULT_MSG SUNDIALS_LIBRARIES SUNDIALS_INCLUDE_DIRS)

MARK_AS_ADVANCED(
  SUNDIALS_LIBRARIES
  SUNDIALS_INCLUDE_DIRS
  SUNDIALS_LIBRARY_DIR
)
