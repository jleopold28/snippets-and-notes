# determine the compiler to use for Ada programs
#
# Sets the following variables:
#   CMAKE_Ada_COMPILER
#   CMAKE_COMPILER_IS_GNUAda
#   CMAKE_Ada_LINKER
#   CMAKE_Ada_BINDER

IF(NOT CMAKE_Ada_COMPILER)
  SET(CMAKE_Ada_COMPILER /usr/bin/gcc)
  MESSAGE("GNU Ada Compiler GNAT1 used for GTSIMS compilation.")
ENDIF(NOT CMAKE_Ada_COMPILER)
MARK_AS_ADVANCED(CMAKE_Ada_COMPILER)

IF(NOT CMAKE_Ada_COMPILER_ID_RUN)
  SET(CMAKE_Ada_COMPILER_ID_RUN 1)
#But we only support GNAT right now
  SET(CMAKE_COMPILER_IS_GNUAda 1)
  SET(CMAKE_Ada_COMPILER_ID "GNU")
#Not attempting support for non-Linux OS at the moment
  SET(CMAKE_Ada_PLATFORM_ID "Linux")
ENDIF(NOT CMAKE_Ada_COMPILER_ID_RUN)

IF(NOT CMAKE_Ada_LINKER)
  SET(CMAKE_Ada_LINKER /usr/bin/gnatlink)
  MESSAGE("GNU Ada Linker at /usr/bin/gnatlink used for GTSIMS linking.")
ENDIF(NOT CMAKE_Ada_LINKER)
MARK_AS_ADVANCED(CMAKE_Ada_LINKER)

IF(NOT CMAKE_Ada_BINDER)
  SET(CMAKE_Ada_BINDER /usr/bin/gnatbind)
  MESSAGE("GNU Ada Binder at /usr/bin/gnatbind used for GTSIMS binding.")
ENDIF(NOT CMAKE_Ada_BINDER)
MARK_AS_ADVANCED(CMAKE_Ada_BINDER)

IF(NOT CMAKE_Ada_BUILDER)
  SET(CMAKE_Ada_BUILDER /usr/bin/gnatmake)
  MESSAGE("GNU Ada Builder at /usr/bin/gnatmake used for GTSIMS building.")
ENDIF(NOT CMAKE_Ada_BUILDER)
MARK_AS_ADVANCED(CMAKE_Ada_BUILDER)

#reset to defaults if otherwise established
IF(NOT CMAKE_Ada_COMPILER_ID_RUN)
  SET(CMAKE_CXX_COMPILER_ID_RUN 1)
  SET(CMAKE_COMPILER_IS_Linux 1)
  SET(CMAKE_COMPILER_IS_GNUAda 1)
ENDIF(NOT CMAKE_Ada_COMPILER_ID_RUN)

INCLUDE(CMakeFindBinUtils)
# configure all variables set in this file
if(NOT CMAKEDEV)
  CONFIGURE_FILE(${EXTRAMODULES}/CMakeAdaCompiler.cmake.in
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeAdaCompiler.cmake
    @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
    )
else()
  CONFIGURE_FILE(${EXTRAMODULES}/CMakeAdaCompiler.cmake.in
    ${CMAKE_PLATFORM_INFO_DIR}/CMakeAdaCompiler.cmake
    @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
    )
endif()

SET(CMAKE_Ada_COMPILER_ENV_VAR "ADA")
