# usage: set(QXT_FIND_COMPONENTS Berkeley Core Gui Network Sql Web Zeroconf) <-- choose any desired components
# minimum user competency alert: "Core" should always be specified as a find component since all qxt components depend upon it
#
# The module defines the following variables:
#  QXT_FOUND - the system has Qxt
#  QXT_INCLUDE_DIRS - aggregate Qxt include directories
#  QXT_LIBRARY - aggregate Qxt libraries
#  QXT_VERSION_STRING - version

IF(QXT_INCLUDE_DIRS)
  #already in cache
  SET(QXT_FIND_QUIETLY TRUE)
ENDIF(QXT_INCLUDE_DIRS)

set(component_includes)
set(component_libraries)
FOREACH(component ${QXT_FIND_COMPONENTS})
  STRING(TOLOWER ${component} lcomponent)
  FIND_PATH(QXT_${component}_INCLUDE_DIR
    NAMES qxt${lcomponent}.h
    PATHS /usr/include/Qxt${component})
  list(APPEND component_includes "${QXT_${component}_INCLUDE_DIR}")
  FIND_LIBRARY(QXT_${component}_LIBRARY
    NAMES Qxt${component}
    PATHS /usr/lib64 /usr/lib)
  list(APPEND component_libraries "${QXT_${component}_LIBRARY}")
ENDFOREACH(component)
set(QXT_INCLUDE_DIRS "${component_includes}")
set(QXT_LIBRARIES "${component_libraries}")

IF(EXISTS "${QXT_Core_INCLUDE_DIR}/qxtglobal.h")
    FILE(STRINGS "${QXT_Core_INCLUDE_DIR}/qxtglobal.h" QXT_H REGEX "^#define QXT_VERSION_STR \"[^\"]*\"$")
    STRING(REGEX REPLACE "^.*QXT_VERSION_STR \"([0-9]+).*$" "\\1" QXT_VERSION_MAJOR "${QXT_H}")
    STRING(REGEX REPLACE "^.*QXT_VERSION_STR \"[0-9]+\\.([0-9]+).*$" "\\1" QXT_VERSION_MINOR  "${QXT_H}")
    STRING(REGEX REPLACE "^.*QXT_VERSION_STR \"[0-9]+\\.[0-9]+\\.([0-9]+).*$" "\\1" QXT_VERSION_PATCH "${QXT_H}")
    SET(QXT_VERSION_STRING "${QXT_VERSION_MAJOR}.${QXT_VERSION_MINOR}.${QXT_VERSION_PATCH}")
ENDIF()

IF(QXT_INCLUDE_DIRS AND QXT_LIBRARIES)
  SET(QXT_FOUND TRUE)
  SET(QXT_LIBRARY_DIR ${QXT_Core_LIBRARY})
ELSE(QXT_INCLUDE_DIRS AND QXT_LIBRARIES)
  SET(QXT_FOUND FALSE)
  SET(QXT_LIBRARY_DIR)
ENDIF(QXT_INCLUDE_DIRS AND QXT_LIBRARIES)

#handle the QUIETLY and REQUIRED arguments
include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Qxt DEFAULT_MSG QXT_LIBRARIES QXT_VERSION_STRING)

mark_as_advanced (
  QXT_LIBRARIES
  QXT_INCLUDE_DIRS
  QXT_VERSION_STRING)
