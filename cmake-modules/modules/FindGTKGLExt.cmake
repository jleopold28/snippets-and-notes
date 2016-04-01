# Created from scratch
#
# - Try to find GTKGL
# Once done this will define
#
#  GTKGL_FOUND			- system has GTKGL
#  GTKGL_CONFIG_INCLUDE_DIR	- the GTKGL config include directory
#  GTKGL_INCLUDE_DIR		- the GTKGL include directory
#  GTKGL_LIBRARY_DIR		- where the libraries are
#  GTKGL_LIBRARIES		- link libraries to use GTKGL
#

IF (GTKGL_INCLUDE_DIR)
  #already in cache
  SET(GTKGL_FIND_QUIETLY TRUE)
ENDIF(GTKGL_INCLUDE_DIR)

IF(WIN32) #likely will not work
  #MSVC support omitted
  FIND_PATH(GTKGL_CONFIG_INCLUDE_DIR gdkglext-config.h
            PATHS c:/gtk/lib/gtkglext-1.0/include)
  FIND_PATH(GTKGL_INCLUDE_DIR gtk
            PATHS c:/gtk/include/gtkglext-1.0)
  FIND_LIBRARY(GTKGL_LIBRARY
               NAMES gtkglext-x11-1.0}
               PATHS c:/gtk/lib/gtkglext-1.0)
  FIND_LIBRARY(GDKGL_LIBRARY
               NAMES gdkglext-x11-1.0
               PATHS c:/gtk/lib/gtkglext-1.0)
ELSE(WIN32)
  FIND_PATH(GTKGL_CONFIG_INCLUDE_DIR gdkglext-config.h
            PATHS /usr/lib64/gtkglext-1.0/include
                  /usr/lib/gtkglext-1.0/include)
  FIND_PATH(GTKGL_INCLUDE_DIR gtk
            PATHS /usr/include/gtkglext-1.0)
  FIND_LIBRARY(GTKGL_LIBRARY
               NAMES gtkglext-x11-1.0
               PATHS /usr/lib64/gtkglext-1.0
                     /usr/lib/gtkglext-1.0)
  FIND_LIBRARY(GDKGL_LIBRARY
               NAMES gdkglext-x11-1.0
               PATHS /usr/lib64/gtkglext-1.0
                     /usr/lib/gtkglext-1.0)
ENDIF(WIN32)

GET_FILENAME_COMPONENT(GTKGL_LIBRARY_DIR ${GTKGL_LIBRARY} PATH)

# handle the QUIETLY and REQUIRED arguments and set GTKGL_FOUND to TRUE if 
# all listed variables are TRUE

IF(GTKGL_INCLUDE_DIR AND GTKGL_CONFIG_INCLUDE_DIR AND GTKGL_LIBRARY AND GDKGL_LIBRARY)
  SET(GTKGL_FOUND TRUE)
  SET(GTKGL_LIBRARY_DIR ${GTKGL_LIBRARY})
  SET(GTKGL_LIBRARIES ${GTKGL_LIBRARY} ${GDKGL_LIBRARY} CACHE FILEPATH "The GTKGLExtension Libraries" FORCE)
ELSE(GTKGL_INCLUDE_DIR AND GTKGL_CONFIG_INCLUDE_DIR AND GTKGL_LIBRARY AND GDKGL_LIBRARY)
  SET(GTKGL_FOUND FALSE)
  SET(GTKGL_LIBRARY_DIR)
ENDIF(GTKGL_INCLUDE_DIR AND GTKGL_CONFIG_INCLUDE_DIR AND GTKGL_LIBRARY AND GDKGL_LIBRARY)

INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GTKGL DEFAULT_MSG GTKGL_LIBRARIES GTKGL_INCLUDE_DIR GTKGL_CONFIG_INCLUDE_DIR)

MARK_AS_ADVANCED(
  GTKGL_LIBRARIES
  GTKGL_CONFIG_INCLUDE_DIR
  GTKGL_INCLUDE_DIR
  GTKGL_LIBRARY_DIR)
