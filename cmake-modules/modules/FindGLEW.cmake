# Adapted from "openlibraries.org" svn trunk
#
# - Try to find GLEW
# Once done this will define
#
#  GLEW_FOUND		- system has GLEW
#  GLEW_INCLUDE_DIR	- the GLEW include directory
#  GLEW_LIBRARY_DIR	- where the libraries are
#  GLEW_LIBRARY		- link libraries to use GLEW
#

IF (GLEW_INCLUDE_DIR)
  #already in cache
  SET(GLEW_FIND_QUIETLY TRUE)
ENDIF(GLEW_INCLUDE_DIR)

IF(WIN32)
  #MSVC support omitted
  FIND_PATH(GLEW_INCLUDE_DIR gl/glew.h gl/wglew.h
            PATHS c:/glew/include)
  SET(GLEW_NAMES glew32 glew64)
  FIND_LIBRARY(GLEW_LIBRARY
               NAMES ${GLEW_NAMES}
               PATHS c:/glew/lib)
ELSE(WIN32)
  FIND_PATH(GLEW_INCLUDE_DIR glew.h wglew.h
            PATHS /usr/include /usr/local/include
            PATH_SUFFIXES gl/ GL/)
  SET(GLEW_NAMES glew GLEW)
  FIND_LIBRARY(GLEW_LIBRARY
               NAMES ${GLEW_NAMES}
               PATHS /usr/lib64 /usr/lib /usr/local/lib64 /usr/local/lib)
ENDIF(WIN32)

GET_FILENAME_COMPONENT(GLEW_LIBRARY_DIR ${GLEW_LIBRARY} PATH)

IF(GLEW_INCLUDE_DIR AND GLEW_LIBRARY)
  SET(GLEW_FOUND TRUE)
  SET(GLEW_LIBRARY_DIR ${GLEW_LIBRARY})
ELSE(GLEW_INCLUDE_DIR AND GLEW_LIBRARY)
  SET(GLEW_FOUND FALSE)
  SET(GLEW_LIBRARY_DIR)
ENDIF(GLEW_INCLUDE_DIR AND GLEW_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set GLEW_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLEW DEFAULT_MSG GLEW_LIBRARY GLEW_INCLUDE_DIR)

MARK_AS_ADVANCED(
  GLEW_LIBRARY
  GLEW_INCLUDE_DIR
  GLEW_LIBRARY_DIR)
