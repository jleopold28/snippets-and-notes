# - Try to find SGE
# Once done this will define
#  
#  SGE_FOUND        - system has SGE
#  SGE_INCLUDE_DIR  - the SGE include directory
#  SGE_LIBRARIES    - Link these to use SGE
#

IF(SGE_INCLUDE_DIR)
  #already in cache
  SET(SGE_FIND_QUIETLY TRUE)
ENDIF(SGE_INCLUDE_DIR)

find_path(SGE_INCLUDE_DIR
  NAMES drmaa.h
  PATHS /opt/sge/include /usr/include/sge)

find_library(SGE_DRMAA_LIBRARY
  NAMES drmaa
  PATHS /opt/sge/lib/lx-amd64 /usr/lib64 /usr/lib)

find_library(SGE_JGDI_LIBRARY
  NAMES jgdi
  PATHS /opt/sge/lib/lx-amd64 /usr/lib64 /usr/lib)

find_library(SGE_JUTI_LIBRARY
  NAMES juti
  PATHS /opt/sge/lib/lx-amd64 /usr/lib64 /usr/lib)

find_library(SGE_SPOOLB_LIBRARY
  NAMES spoolb
  PATHS /opt/sge/lib/lx-amd64 /usr/lib64 /usr/lib)

find_library(SGE_SPOOLC_LIBRARY
  NAMES spoolc
  PATHS /opt/sge/lib/lx-amd64 /usr/lib64 /usr/lib)

set(SGE_LIBRARIES ${SGE_DRMAA_LIBRARY} ${SGE_JGDI_LIBRARY} ${SGE_JUTI_LIBRARY} ${SGE_SPOOLB_LIBRARY} ${SGE_SPOOLC_LIBRARY})

IF(SGE_INCLUDE_DIR AND SGE_DRMAA_LIBRARY)
  SET(SGE_FOUND TRUE)
  SET(SGE_LIBRARY_DIR ${SGE_DRMAA_LIBRARY})
ELSE(SGE_INCLUDE_DIR AND SGE_DRMAA_LIBRARY)
  SET(SGE_FOUND FALSE)
  SET(SGE_LIBRARY_DIR)
ENDIF(SGE_INCLUDE_DIR AND SGE_DRMAA_LIBRARY)

#handle the QUIETLY and REQUIRED arguments
include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(SGE DEFAULT_MSG SGE_LIBRARIES)

mark_as_advanced (
  SGE_LIBRARIES
  SGE_INCLUDE_DIR
  SGE_VERSION_STRING)
