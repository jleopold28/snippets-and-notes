# WARNING: Do not use FindRTI.cmake packaged with CMake.  It will not work, but this will.
#
# This code sets the following variables:
#  CERTI_INCLUDE_DIR = the directory where RTI includes file are found
#  CERTI_LIBRARIES = The libraries to link against to use RTI
#  CERTI_FOUND = Set to FALSE if any HLA RTI was not found
#

IF(CERTI_INCLUDE_DIR)
  #already in cache
  SET(CERTI_FIND_QUIETLY TRUE)
ENDIF(CERTI_INCLUDE_DIR)

FIND_PATH(CERTI_INCLUDE_DIR
  NAMES RTI.hh
  PATHS /usr/include
  DOC "The RTI Include Files")

FIND_LIBRARY(CERTI_LIBRARY
  NAMES RTI-NGd RTI1516d
  PATHS /usr/lib64 /usr/lib
  DOC "The RTI Libraries")

FIND_LIBRARY(CERTI_FEDTIME_LIBRARY
  NAMES FedTimed FedTime1516d
  PATHS /usr/lib64 /usr/lib
  DOC "The FedTime Library")

# handle the QUIETLY and REQUIRED arguments and set CERTI_FOUND to TRUE if 
# all listed variables are TRUE
IF(CERTI_INCLUDE_DIR AND CERTI_LIBRARY AND CERTI_FEDTIME_LIBRARY)
  SET(CERTI_FOUND TRUE)
  SET(CERTI_LIBRARIES ${CERTI_LIBRARY} ${CERTI_FEDTIME_LIBRARY} CACHE FILEPATH "The RTI Libraries" FORCE)
ELSE(CERTI_INCLUDE_DIR AND CERTI_LIBRARY AND CERTI_FEDTIME_LIBRARY)
  SET(CERTI_FOUND FALSE)
ENDIF()

MARK_AS_ADVANCED(
  CERTI_LIBRARIES
  CERTI_INCLUDE_DIR)

INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CERTI DEFAULT_MSG CERTI_LIBRARIES CERTI_INCLUDE_DIR)
