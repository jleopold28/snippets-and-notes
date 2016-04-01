#CMakeDev is toolchain variable signifying CMake >= 2.8.8

INCLUDE(CMakeTestCompilerCommon)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected Ada compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
IF(NOT CMAKE_Ada_COMPILER_WORKS)
  PrintTestCompilerStatus("Ada" "")
  FILE(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/cmTryCompileExec.adb
    "with Ada.Text_IO;\n"
    "use Ada.Text_IO;\n"
    "procedure cmTryCompileExec is\n"
    "begin\n"
    "Put(\"Hello World\");\n"
    "end cmTryCompileExec;\n")
  TRY_COMPILE(CMAKE_Ada_COMPILER_WORKS ${CMAKE_BINARY_DIR} 
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/cmTryCompileExec.adb
    OUTPUT_VARIABLE __CMAKE_Ada_COMPILER_OUTPUT)
  SET(Ada_TEST_WAS_RUN 1)
ENDIF(NOT CMAKE_Ada_COMPILER_WORKS)

IF(NOT CMAKE_Ada_COMPILER_WORKS AND NOT CMAKEDEV)
  PrintTestCompilerStatus("Ada" " -- broken")
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the Ada compiler works failed with "
    "the following output:\n${__CMAKE_Ada_COMPILER_OUTPUT}\n\n")
  MESSAGE(FATAL_ERROR "The Ada compiler \"${CMAKE_Ada_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${__CMAKE_Ada_COMPILER_OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
ELSE(NOT CMAKE_Ada_COMPILER_WORKS AND NOT CMAKEDEV)
  IF(Ada_TEST_WAS_RUN AND NOT CMAKEDEV)
    PrintTestCompilerStatus("Ada" " -- works")
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
        "Determining if the Ada compiler works passed with "
        "the following output:\n${__CMAKE_Ada_COMPILER_OUTPUT}\n\n")
  ELSEIF(Ada_TEST_WAS_RUN AND CMAKEDEV)
    MESSAGE("Ada cannot be tested on CMake >= 2.8.8.  Please manually "
            "inspect trycompile output to verify gnat.")
  ENDIF(Ada_TEST_WAS_RUN AND NOT CMAKEDEV)
  SET(CMAKE_Ada_COMPILER_WORKS 1 CACHE INTERNAL "")

  IF(CMAKE_Ada_COMPILER_FORCED)
    # The compiler configuration was forced by the user.
    # Assume the user has configured all compiler information.
  ELSE(CMAKE_Ada_COMPILER_FORCED)
    # Try to identify the ABI and configure it into CMakeAdaCompiler.cmake
    INCLUDE(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
    CMAKE_DETERMINE_COMPILER_ABI(Ada ${EXTRAMODULES}/CMakeAdaCompilerABI.adb)
    if(CMAKEDEV)
      CONFIGURE_FILE(
        ${EXTRAMODULES}/CMakeAdaCompiler.cmake.in
        ${CMAKE_PLATFORM_INFO_DIR}/CMakeAdaCompiler.cmake
        @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
        )
      INCLUDE(${CMAKE_PLATFORM_INFO_DIR}/CMakeAdaCompiler.cmake)
    else()
      CONFIGURE_FILE(
        ${EXTRAMODULES}/CMakeAdaCompiler.cmake.in
        ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeAdaCompiler.cmake
        @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
        )
      INCLUDE(${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeAdaCompiler.cmake)
    endif()
  ENDIF(CMAKE_Ada_COMPILER_FORCED)
ENDIF(NOT CMAKE_Ada_COMPILER_WORKS AND NOT CMAKEDEV)

UNSET(__CMAKE_Ada_COMPILER_OUTPUT)
