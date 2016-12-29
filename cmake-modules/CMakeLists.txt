#--------------------BEGIN CONFIGURATION-------------------
#
#Set CMake directories
if(CMAKEDEV AND ELVERSION STREQUAL "6")
  set(CMAKE_ROOT /usr/share/cmake28)
else()
  set(CMAKE_ROOT /usr/share/cmake)
endif()
set(CMAKE_SOURCE_DIR ${PROJECTDIR}/${SRCDIR} CACHE PATH "PROJECT Source Directory" FORCE)
set(CMAKE_INSTALL_PREFIX ${PROJECTDIR} CACHE PATH "Path Before PROJECT Install Directory" FORCE)
set(CMAKE_BINARY_DIR ${PROJECTDIR}/bld${CONFIGNAME} CACHE PATH "PROJECT Build Directory" FORCE)
set(EXTRAMODULES ${CMAKE_SOURCE_DIR}/config CACHE PATH "Location of additional custom CMake Modules" FORCE)
set(CMAKE_MODULE_PATH ${CMAKE_ROOT}/Modules ${EXTRAMODULES})

#Set overall configuration variables
cmake_policy(VERSION 2.8.7)
set(CMAKE_SYSTEM_PREFIX_PATH /usr / CACHE PATH "System Prefix Path for all finds" FORCE)
set(CMAKE_SYSTEM_INCLUDE_PATH /usr/include CACHE PATH "System Include lookup path for CMake" FORCE)
set(CMAKE_SYSTEM_PROGRAM_PATH /bin /usr/bin CACHE PATH "System Binary lookup path for CMake" FORCE)
set(CMAKE_FIND_LIBRARY_PREFIXES lib "")
set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a)

#Extra library pathing logic and the libraries themselves
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS TRUE CACHE "Use 64 bit or 32 bit paths for Lib finds" FORCE)
set(CMAKE_SYSTEM_LIBRARY_PATH /lib64 /usr/lib64 CACHE PATH "System Lib lookup path" FORCE)

if(ELVERSION STREQUAL "7")
  find_library(GNATLIB NAMES gnat-4.8 PATHS /lib64 /usr/lib64)
  set(Fortran_LINK_DIR "/usr/lib/gcc/x86_64-redhat-linux/${GCCVERSION}" CACHE PATH "Fortran runtime library directories for other languages linking Fortran executables" FORCE)
  set(CMAKE_Ada_IMPLICIT_LINK_DIRECTORIES /usr/lib/gcc/x86_64-redhat-linux/${GCCVERSION}/adalib /lib64 /usr/lib64 ${Fortran_LINK_DIR} CACHE PATH "Implicit link library directories for gnatlink" FORCE)
  set(ADALINKER "/usr/bin/g++" CACHE PATH "Linker executable to use within gnatmake" FORCE)
elseif(ELVERSION STREQUAL "6" AND GCC48)
  find_library(GNATLIB NAMES gnat-4.8 PATHS /lib64 /usr/lib64)
  set(Fortran_LINK_DIR "/usr/lib/gcc/x86_64-redhat-linux7E/${GCCVERSION}" CACHE PATH "Fortran runtime library directories for other languages linking Fortran executables" FORCE)
  set(CMAKE_Ada_IMPLICIT_LINK_DIRECTORIES /usr/lib/gcc/x86_64-redhat-linux7E/${GCCVERSION}/adalib /lib64 /usr/lib64 ${Fortran_LINK_DIR} CACHE PATH "Implicit link library directories for gnatlink" FORCE)
  set(ADALINKER "/usr/bin/g++48" CACHE PATH "Linker executable to use within gnatmake" FORCE)
elseif(ELVERSION STREQUAL "6" AND NOT GCC48)
  find_library(GNATLIB NAMES gnat-4.4 PATHS /lib64 /usr/lib64)
  set(Fortran_LINK_DIR "/usr/lib/gcc/x86_64-redhat-linux/${GCCVERSION}" CACHE PATH "Fortran runtime library directories for other languages linking Fortran executables" FORCE)
  set(CMAKE_Ada_IMPLICIT_LINK_DIRECTORIES /usr/lib/gcc/x86_64-redhat-linux/${GCCVERSION}/adalib /lib64 /usr/lib64 ${Fortran_LINK_DIR} CACHE PATH "Implicit link library directories for gnatlink" FORCE)
  set(ADALINKER "/usr/bin/g++" CACHE PATH "Linker executable to use within gnatmake" FORCE)
elseif(ELVERSION STREQUAL "5")
  find_library(GNATLIB NAMES gnat-4.1 PATHS /lib64 /usr/lib64)
  set(Fortran_LINK_DIR "/usr/lib/gcc/x86_64-redhat-linux6E/${GCCVERSION}" CACHE PATH "Fortran runtime library directories for other languages linking Fortran executables" FORCE)
  set(CMAKE_Ada_IMPLICIT_LINK_DIRECTORIES /usr/lib/gcc/x86_64-redhat-linux/4.1.2/adalib /lib64 /usr/lib64 ${Fortran_LINK_DIR} CACHE PATH "Implicit link library directories for gnatlink" FORCE)
  set(ADALINKER "/usr/bin/g++44" CACHE PATH "Linker executable to use within gnatmake" FORCE)
endif()
find_library(PTHREADLIB NAMES pthread PATHS /lib64 /usr/lib64)
string(REPLACE "lib/" "lib64/" GNATLIB ${GNATLIB})#bug in CMake sometimes causes it to ignore all suggestions to search x86_64 first
string(REPLACE "lib/" "lib64/" PTHREADLIB ${PTHREADLIB})#see previous line
set(CMAKE_EXTRA_LINK_DIRS "-L${Fortran_LINK_DIR}" CACHE PATH "Link library directories for subverting poor implicit library selection by CMake" FORCE)#help subvert CMake's poor implicit library selection

#Library rules and specifications
set(CMAKE_STATIC_LIBRARY_PREFIX "" CACHE STRING "Prefix for linked static libraries" FORCE)
set(CMAKE_STATIC_LIBRARY_SUFFIX "" CACHE STRING "Suffix for linked static libraries" FORCE)
set(CMAKE_SHARED_LIBRARY_PREFIX "" CACHE STRING "Prefix for linked shared libraries" FORCE)
set(CMAKE_SHARED_LIBRARY_SUFFIX "" CACHE STRING "Suffix for linked shared libraries" FORCE)
set(CMAKE_AR /usr/bin/ar CACHE FILEPATH "Path to AR" FORCE)
set(CMAKE_RANLIB /usr/bin/ranlib CACHE FILEPATH "Path to RANLIB" FORCE)
set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_APPEND "<CMAKE_AR> rv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_APPEND "<CMAKE_AR> rv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Fortran_ARCHIVE_CREATE "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Fortran_ARCHIVE_APPEND "<CMAKE_AR> rv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Fortran_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Ada_ARCHIVE_CREATE "<CMAKE_AR> crv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Ada_ARCHIVE_APPEND "<CMAKE_AR> rv <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_Ada_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET> <LINK_FLAGS> <OBJECTS>")

#Legacy preprocessor defines shared by all languages and user configuration switches; despite how odd these look they must be retained for the future due to unmaintained but utilized code
add_definitions(-DSYS_LINUX -DLINUX_RHEL5_64 -DMACH_I386)

if(USEOPENGL)
  if(USEOPENGLRENDER)
    add_definitions(-DHAVE_OPENGL_RENDERER)
    if(USESGIP)
      add_definitions(-DHAVE_SGIP)
    else()
      set(SGIP_LIBRARIES "" CACHE STRING "Set of SGIP OpenGL Rendering libraries for SGIP-on or dummy" FORCE)
    endif()
  else()
    set(SGIP_LIBRARIES "" CACHE STRING "Set of SGIP OpenGL Rendering libraries for SGIP-on or dummy" FORCE)
  endif()
  if(USEOPENGLFLR)
    add_definitions(-DHAVE_OPENGL_FLR_RENDER)
  else()
    set(FLRRENDERLIB "" CACHE STRING "Set of Flare-Rendering libraries for OpenGLFlare-on build or dummy" FORCE)
  endif()
  if(USEOPENGLSMOKE)
    add_definitions(-DHAVE_OPENGL_SMOKE_RENDER)
  else()
    set(SMOKERENDERLIB "" CACHE STRING "Set of Smoke-Rendering libraries for OpenGLSmoke-on build or dummy" FORCE)
  endif()
else()
  set(RENDERLIB "" CACHE STRING "Set of Rendering libraries for OpenGL-on build or dummy" FORCE)
  set(FLRRENDERLIB "" CACHE STRING "Set of Flare-Rendering libraries for OpenGLFlare-on build or dummy" FORCE)
  set(SMOKERENDERLIB "" CACHE STRING "Set of Smoke-Rendering libraries for OpenGLSmoke-on build or dummy" FORCE)
  set(OPENGLLIBS "" CACHE STRING "Dummy value for OPENGLLIBS when switched off" FORCE)
  set(SGIP_LIBRARIES "" CACHE STRING "Set of SGIP OpenGL Rendering libraries for SGIP-on or dummy" FORCE)
endif()
if(USECUDA)
  add_definitions(-DCUDA)
else()
  set(RETLIB "" CACHE STRING "CUDA Reticle library for CUDA-on build or dummy" FORCE)
  set(CUDALIBS "" CACHE STRING "Composite CUDA libraries for CUDA-on build or dummy" FORCE)
  set(CUDAAUXLIBS "" CACHE STRING "CUDA Auxiliary libraries for CUDA-on build or dummy" FORCE)
endif()
if(USEFLTS)
  if(NOT CLASSED)
    set(FLTSDIR $ENV{FLT2_DIR} CACHE PATH "FLTS external components directory location (unCLASSED configuration)" FORCE)
    if(NOT FLTSDIR)
      MESSAGE(FATAL_ERROR "The FLT2_DIR environment variable must be set for FLTS-ON configurations.  It should be set to the desired path for the external FLTS components.")
    endif()
    set(FLTS_INCLUDE_DIR ${FLTSDIR}/include CACHE PATH "FLTS include directory for building within the flts_if directory (unCLASSED configuration)" FORCE)
  endif()
  add_definitions(-DHAVE_FLTS)
else()
  set(FLTSLIB "" CACHE STRING "FLTS Libraries for FLTS-on build or dummy" FORCE)
endif()
if(USEFLAME AND PROJECTUNIFIEDISE AND CLASSED AND ELVERSION STREQUAL "5")
  add_definitions(-DHAVE_FLAME -DHAVE_NSWC_FLAME_CODE)
  set(FLAMELIB flame.a CACHE FILEPATH "Flame library for Flame-on build or dummy" FORCE)
else()
  add_definitions(-DNO_FLAME_CODE)
  set(FLAMELIB "" CACHE FILEPATH "Flame library for Flame-on build or dummy" FORCE)
endif()
if(USESMOKE)
  add_definitions(-DHAVE_SMOKE_CODE)
else()
  add_definitions(-DNO_SMOKE_CODE)
endif()
if(USEOCEAN)
  add_definitions(-DHAVE_OCEAN_CODE)
else()
  add_definitions(-DNO_OCEAN_CODE)
endif()
if(USEMODTRAN5)
  add_definitions(-DUSE_MODTRAN5)
endif()
#USESENSE refers only to components outside of PROJECTUNIFIEDISE.  ISE has sense_ISE whose libsense is always linked against (hardcoded) regardless of configuration.
if(USESENSE)
  add_definitions(-DSENSE -DHAVE_SENSE_CODE)
  set(SENSELIB sense.a CACHE FILEPATH "Sense libraries for Sense-on build or dummy" FORCE)
else()
  set(SENSELIB "" CACHE STRING "Sense libraries for Sense-on build or dummy" FORCE)
endif()
if(USESIL)
  add_definitions(-DHAVE_SIL)
  set(SILLIB silutil.a CACHE FILEPATH "SIL library for SIL-on build or dummy" FORCE)
else()
  set(SILLIB "" CACHE STRING "SIL library for SIL-on build or dummy" FORCE)
endif()
if(USESAIL)
  add_definitions(-DHAVE_SAIL)
  set(SAILLIBS sailapi.a simsarch.a sailutil.a CACHE FILEPATH "SAIL libraries for SAIL-on build or dummy" FORCE)
else()
  set(SAILLIBS "" CACHE STRING "SAIL libraries for SAIL-on build or dummy" FORCE)
endif()
if(PROPRIETARY)
  add_definitions(-DCOMPANY_PROPRIETARY)
#MODTRAN4 and MODTRAN5 libraries are both target-named "modtran.so" and cannot be in the same configuration
  set(ATMOSLIB modtran.so CACHE FILEPATH "Target name for Modtran/Lowtran library links" FORCE)
else()
  set(ATMOSLIB lowtran.so CACHE FILEPATH "Target name for Modtran/Lowtran library links" FORCE)
endif()
#removed from build configure options; restore if necessary
if(TRACEMALLOC)
  add_definitions(-Dmalloc=trace_malloc -Dcalloc=trace_calloc -Drealloc=trace_realloc -Dfree=trace_free)
endif()

#C/C++ Flags of all kinds
set(CFLAGSINIT "")
if(GCC48 OR ELVERSION STREQUAL "7")
  set(CXXFLAGSINIT "-std=c++11")
else()
  set(CXXFLAGSINIT "")
endif()

if(PROFILE)
  set(CBOTHFLAGSPROFILER "-fprofile-generate -fprofile-use -fprofile-correction -pg")
else()
  set(CBOTHFLAGSPROFILER "")
endif()

if(DEBUG)
  set(CBOTHFLAGSDEBUG "-g -Wall")
else()
  set(CBOTHFLAGSDEBUG "-O3 -fPIC -funroll-loops")
endif()

set(CMAKE_C_FLAGS "${CFLAGSINIT} ${CBOTHFLAGSPROFILER} ${CBOTHFLAGSDEBUG}" CACHE STRING "C Compiler Flags" FORCE)
set(CMAKE_C_LINK_FLAGS "${CBOTHFLAGSPROFILER}" CACHE STRING "C Link Flags" FORCE)
set(CMAKE_CXX_FLAGS "${CXXFLAGSINIT} ${CBOTHFLAGSPROFILER} ${CBOTHFLAGSDEBUG}"  CACHE STRING "C++ Compiler Flags" FORCE)
set(CMAKE_CXX_LINK_FLAGS "${CBOTHFLAGSPROFILER}"  CACHE STRING "C++ Link Flags" FORCE)

#Legacy Fortran Flags of all kinds
set(FPPFLAGS -DHAVE_GETARG -DIMPL_NONE -DDONT_HAVE_FDATE)#eventually passed into add_custom_command so no "" to ensure we avoid whitespace escapes
#gfpp  add_definitions(-DHAVE_GETARG -DIMPL_NONE -DDONT_HAVE_FDATE)

#add -fimplicit-none when feeling brave
set(FFLAGSINIT "-funderscoring -ffixed-line-length-72 -fno-automatic -fno-range-check -nocpp")
#gfpp  set(FFLAGSINIT "-funderscoring -ffixed-line-length-72 -fno-automatic -fno-range-check -cpp -P")#GF-FPP only runs in traditional mode, so flag for it is nonexistent and unnecessary

if(PROFILE)
  set(FFLAGSPROFILER "-fprofile-generate -fprofile-use -fprofile-correction -pg")
else()
  set(FFLAGSPROFILER "")
endif()

if(DEBUG)
  if(GCC48)
    set(FFLAGSDEBUG "-g -Wall -fcheck=all -fbacktrace")
  else()
    set(FFLAGSDEBUG "-g -Wall -fbounds-check -fbacktrace")
  endif()
else()
  set(FFLAGSDEBUG "-O3")#cannot use -funroll-loops because we likely have extended range do loops somewhere
endif()

set(CMAKE_Fortran_FLAGS "${FFLAGSINIT} ${FFLAGSPROFILER} ${FFLAGSDEBUG}" CACHE STRING "Fortran Compiler Flags" FORCE)
set(CMAKE_Fortran_LINK_FLAGS "${FFLAGSPROFILER}" CACHE STRING "Fortran Link Flags" FORCE)

#Ada Flags of all kinds (Ada support custom added to CMake; do not expect capabilities equivalent to C, C++, or Fortran)
set(AFLAGSINIT "-gnatec${EXTRAMODULES}/gnat.adc")

set(CMAKE_Ada_SIZEOF_DATA_PTR 8 CACHE STRING "Ada 64 bit or 32 bit ABI" FORCE)

if(PROFILE)
  if(NOT ELVERSION STREQUAL "5")
    set(AFLAGSPROFILER "-fprofile-generate -fprofile-use -fprofile-correction -pg")
  else()
    set(AFLAGSPROFILER "-fprofile-generate -fprofile-use -pg")
  endif()
else()
  set(AFLAGSPROFILER "")
endif()

if(DEBUG)
  set(AFLAGSDEBUG "-g -Wall")
else()
  set(AFLAGSDEBUG "-O3 -fPIC -funroll-loops")
endif()

set(CMAKE_Ada_FLAGS "${AFLAGSINIT} ${AFLAGSPROFILER} ${AFLAGSDEBUG}" CACHE STRING "Ada Compiler Flags" FORCE)
set(CMAKE_Ada_LINK_FLAGS "--LINK=${ADALINKER} ${AFLAGSPROFILER} ${CMAKE_EXTRA_LINK_DIRS}" CACHE STRING "Ada Link Flags" FORCE)#supposedly "-s" is a no downside way to reduce the size of Ada executables during the linking process; noted here for possible experimentation later
set(CMAKE_Ada_BIND_FLAGS "-x -static" CACHE STRING "Ada Bind Flags" FORCE)

#Compiler and Linker overloads, redefines, and specifications
set(Fortran_LINK_LIB "-lgfortranbegin -lgfortran" CACHE STRING "Fortran runtime libraries for other languages linking Fortran executables" FORCE)
set(CMAKE_Fortran_COMPILER_ID GNU CACHE STRING "GNUFortran is the Fortran Compiler" FORCE)#CMake eventually identifies the Fortran compiler as GNU (-nocpp likely blocking it during ABI detection), but manually forcing it here so that it is immediately recognized prior to the all-important compiler tests
set(CMAKE_Fortran_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <CMAKE_Fortran_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${Fortran_LINK_LIB}")#subverting poor cmake implicit library selection behavior
set(CMAKE_Ada_Fortran_IMPLICIT_LINK_LIBS gfortranbegin gfortran m CACHE STRING "GFortran Implicit link libraries for gnatlink" FORCE)
set(CMAKE_Ada_Fortran_LINK_LIBS "-lgfortranbegin -lgfortran -lm" CACHE STRING "GFortran link libraries for gnatlink" FORCE)

set(CMAKE_Ada_COMPILER_ABI ELF CACHE STRING "Ada ABI" FORCE)#until we have a legit way of doing this (see /src/config/CMakeAdaCompilerABI.adb); even with this and the below SIZEOF_DATA_PTR, the Ada ABI detector will technically fail during configuration initialization, but it does not matter since we are forcing the issue and not auto-detecting
set(CMAKE_Ada_IMPLICIT_LINK_LIBS ${GNATLIB} ${PTHREADLIB} CACHE STRING "Implicit link libraries for gnatlink" FORCE)
set(CMAKE_Ada_IMPLICIT_LINK_LIBRARIES ${CMAKE_Ada_IMPLICIT_LINK_LIBS} ${CMAKE_Ada_Fortran_IMPLICIT_LINK_LIBS} CACHE STRING "Total Implicit Link Libraries for gnatlink" FORCE)

set(CMAKE_Fortran_PLATFORM_ID Linux CACHE STRING "Fortran is compiling on Linux" FORCE)#for some reason the CMake ABI Fortran Compiler Platform checks are unable to identify Linux
#gfpp remove this fortran overload so defines return to the macro from general modules
set(CMAKE_Fortran_COMPILE_OBJECT "<CMAKE_Fortran_COMPILER> <FLAGS> -c <SOURCE> -o <OBJECT>")#excluding defines
set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${Fortran_LINK_LIB}")#subverting poor CMake implicit library selections
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER>  <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${Fortran_LINK_LIB}")#subverting poor CMake implicit library selections
if(NOT ELVERSION STREQUAL "5")#-aL/-aO actually work correctly on RHEL6/CMAKE 2.8.7/GNAT44, but that scenario gives false positive link succeed statements; however, removing -aO and -aL forces local .o/.ali recompilation of internal dependencies since gnatmake does not "short-circuit" the compilation phase after gnatmake discovers -aLfoo/executablesource.ali files; this is inefficient yet works until we can instruct -aL/-aO to find all the object and ali locations correctly; note that removing -aL and retaining -aO will cause recompilation but provides no benefits and fails anyway
  set(CMAKE_Ada_LINK_EXECUTABLE "${CMAKE_Ada_BUILDER} <LINK_FLAGS> <TARGET_BASE>.adb -cargs <FLAGS> -bargs ${CMAKE_Ada_BIND_FLAGS} -largs <CMAKE_Ada_LINK_FLAGS> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${CMAKE_Ada_Fortran_LINK_LIBS}")#be careful to note that all changes to the custom Ada modules will need to have any corresponding changes made to this line
#  set(CMAKE_Ada_LINK_EXECUTABLE "${CMAKE_Ada_BUILDER} -aO<OBJECT_DIR> -aL<OBJECT_DIR> <LINK_FLAGS> <TARGET_BASE>.adb -cargs <FLAGS> -bargs ${CMAKE_Ada_BIND_FLAGS} -largs <CMAKE_Ada_LINK_FLAGS> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${CMAKE_Ada_Fortran_LINK_LIBS}")#be careful to note that all changes to the custom Ada modules will need to have any corresponding changes made to this line
else()
  set(CMAKE_Ada_LINK_EXECUTABLE "${CMAKE_Ada_BUILDER} -aO<OBJECT_DIR> <LINK_FLAGS> <TARGET_BASE>.adb -cargs <FLAGS> -bargs ${CMAKE_Ada_BIND_FLAGS} -largs <CMAKE_Ada_LINK_FLAGS> ${CMAKE_EXTRA_LINK_DIRS} <LINK_LIBRARIES> ${CMAKE_Ada_Fortran_LINK_LIBS}")#be careful to note that all changes to the custom Ada modules will need to have any corresponding changes made to this line
endif()

#Compiler/Linker info
if(ELVERSION STREQUAL "7")
  set(CMAKE_C_COMPILER /usr/bin/gcc)
  set(CMAKE_CXX_COMPILER /usr/bin/g++)
  set(CMAKE_Fortran_COMPILER /usr/bin/gfortran)
  set(CMAKE_Ada_BINDER /usr/bin/gnatbind CACHE FILEPATH "Ada Binding Executable" FORCE)
  set(CMAKE_Ada_LINKER /usr/bin/gnatlink CACHE FILEPATH "Ada Linking Executable" FORCE)
  set(CMAKE_Ada_COMPILER /usr/bin/gcc)
  set(CMAKE_Ada_BUILDER /usr/bin/gnatmake CACHE FILEPATH "Ada Total Builder (Compile/Bind/Link)" FORCE)
elseif(ELVERSION STREQUAL "6" AND GCC48)
  set(CMAKE_C_COMPILER /usr/bin/gcc48)
  set(CMAKE_CXX_COMPILER /usr/bin/g++48)
  set(CMAKE_Fortran_COMPILER /usr/bin/gfortran48)
  set(CMAKE_Ada_BINDER /usr/bin/gnatbind48 CACHE FILEPATH "Ada Binding Executable" FORCE)
  set(CMAKE_Ada_LINKER /usr/bin/gnatlink48 CACHE FILEPATH "Ada Linking Executable" FORCE)
  set(CMAKE_Ada_COMPILER /usr/bin/gcc48)
  set(CMAKE_Ada_BUILDER /usr/bin/gnatmake48 CACHE FILEPATH "Ada Total Builder (Compile/Bind/Link)" FORCE)
elseif(ELVERSION STREQUAL "6" AND NOT GCC48)
  set(CMAKE_C_COMPILER /usr/bin/gcc)
  set(CMAKE_CXX_COMPILER /usr/bin/g++)
  set(CMAKE_Fortran_COMPILER /usr/bin/gfortran)
  set(CMAKE_Ada_BINDER /usr/bin/gnatbind CACHE FILEPATH "Ada Binding Executable" FORCE)
  set(CMAKE_Ada_LINKER /usr/bin/gnatlink CACHE FILEPATH "Ada Linking Executable" FORCE)
  set(CMAKE_Ada_COMPILER /usr/bin/gcc)
  set(CMAKE_Ada_BUILDER /usr/bin/gnatmake CACHE FILEPATH "Ada Total Builder (Compile/Bind/Link)" FORCE)
elseif(ELVERSION STREQUAL "5")
  set(CMAKE_C_COMPILER /usr/bin/gcc44)
  set(CMAKE_CXX_COMPILER /usr/bin/g++44)
  set(CMAKE_Fortran_COMPILER /usr/bin/gfortran44)
  set(CMAKE_Ada_BINDER /usr/bin/gnatbind CACHE FILEPATH "Ada Binding Executable" FORCE)
  set(CMAKE_Ada_LINKER /usr/bin/gnatlink CACHE FILEPATH "Ada Linking Executable" FORCE)
  set(CMAKE_Ada_COMPILER /usr/bin/gcc) #EL5 will always be /usr/bin/gcc (gcc-gnat 4.1.x vis a vis gnat1) because 4.4.x gnat is not supported for EL5
  set(CMAKE_Ada_BUILDER /usr/bin/gnatmake CACHE FILEPATH "Ada Total Builder (Compile/Bind/Link)" FORCE)
endif()

set(Fortran_FORMAT FIXED CACHE STRING "Fixed or free format in Fortran source layout" FORCE)

enable_language(C CXX Fortran Ada)

#Modules to gather necessary system packages
INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)

include(FindFLEX)
include(FindBISON)
set(CURSES_NEED_NCURSES TRUE)
include(FindCurses)
include(FindX11)
include(FindLibXml2)
include(FindTCL)
include(FindPVM3)

if(USESAIL)
  set(K2_FIND_COMPONENTS k kmm)
  include(FindK2)
  set(HDF5_USE_STATIC_LIBRARIES FALSE)
  set(HDF5_FIND_COMPONENTS CXX HL)
  include(FindHDF5)
  if(HDF5_FOUND)
    string(REPLACE "_hl" "_hl_cpp" HDF5_hdf5_hl_cpp_LIBRARY ${HDF5_hdf5_hl_LIBRARY})
    set(HDF5_hdf5_hl_cpp_LIBRARY ${HDF5_hdf5_hl_cpp_LIBRARY} CACHE FILEPATH "The HDF5_hdf5_hl_cpp library" FORCE)
  endif()
  set(HDF5LIBS ${HDF5_hdf5_LIBRARY} ${HDF5_hdf5_cpp_LIBRARY} ${HDF5_hdf5_hl_LIBRARY} ${HDF5_hdf5_hl_cpp_LIBRARY} CACHE FILEPATH "Composite HDF5 Libraries or dummy" FORCE)
  include(FindLibXml++)#need >=2.34 version var; libxml++ is dumb and hides its version in its .pc in pkgconfig and it cannot be accessed via CMake's PkgConfig module
  include(FindCERTI)#FindRTI.cmake is a complete failure so use custom module instead
  if(CERTI_FOUND)
    add_definitions(-DRTI_USES_STD_FSTREAM)
  endif()
  include(FindLevmar)
#elseif(USEOPENGL AND CLASSED)#legacy trajplot has k2 depends but is now obsoleted so re-add section only if necessary
  #include(FindKGLExt)
  #set(K2_FIND_COMPONENTS k)
  #include(FindK2)
else()
  set(HDF5LIBS "" CACHE STRING "Composite HDF5 Libraries or dummy" FORCE)
endif()

if(USESAIL OR USESGIP)
  if(NOT CMAKEDEV)
    set(Boost_ADDITIONAL_VERSIONS "1.49" "1.49.0"  "1.50" "1.50.0"  "1.51" "1.51.0" "1.52" "1.52.0"  "1.53" "1.53.0"  "1.54" "1.54.0")
  endif()
  set(Boost_USE_STATIC_LIBS OFF)
  set(Boost_USE_STATIC_RUNTIME OFF)
  set(Boost_FIND_COMPONENTS date_time filesystem system regex)
  set(Boost_FIND_VERSION TRUE)
  set(Boost_FIND_VERSION_MAJOR 1)
  set(Boost_FIND_VERSION_MINOR 46)
  include(FindBoost)
  if("${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}" VERSION_LESS "${Boost_FIND_VERSION}")
    message("The version of Boost found is older than the required ${Boost_FIND_VERSION}.  Before every configuration/build command is executed in this build tree, CMake will attempt to find and configure with an acceptable version of Boost until one is found.")
  endif()
endif()

if(USEOPENGLRENDER OR CLASSED)
  set(QT_QMAKE_EXECUTABLE /usr/bin/qmake-qt4 CACHE FILEPATH "Normal path to QMake so FindQt4 does not fail hard" FORCE)
  if(USEOPENGL)
    set(QT_USE_QTOPENGL TRUE)
  endif()
  include(FindQt4)
endif()

if(CLASSED)
  include(FindSundials)
  include(FindPNG)
endif()

FIND_PACKAGE_HANDLE_STANDARD_ARGS(GNAT DEFAULT_MSG GNATLIB)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PTHREAD DEFAULT_MSG PTHREADLIB)

if(USEOPENGL)
  set(OpenGL_FIND_REQUIRED TRUE)
  include(FindOpGL)#default module finds incorrect drivers
  set(FFmpeg_FIND_COMPONENTS AVCODEC AVFORMAT AVUTIL SWSCALE)
  include(FindFFmpeg)
  set(GLUT_FIND_REQUIRED TRUE)
  include(FindGLUT)
  if(NOT CMAKEDEV)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLUT DEFAULT_MSG GLUT_LIBRARIES)
  endif()
  set(GLEW_FIND_REQUIRED TRUE)
  include(FindGLEW)
  set(OPENGLLIBS ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLUT_glut_LIBRARY} ${GLEW_LIBRARY} /lib64/libm.so.6 CACHE FILEPATH "Composite OpenGL + GLU + GLUT + GLEW libraries" FORCE)#if C code uses OpenGL or CUDA then the cmath library is needed and the library is only implicit in C++ and not C with CMake; what ridiculousness
  if(USEOPENGLRENDER)
    if(USESGIP)
      include(FindGSL)
      set(FLTK_SKIP_FORMS TRUE)
      set(FLTK_SKIP_IMAGES TRUE)
      set(FLTK_SKIP_FLUID TRUE)
      include(FindFLTK)
      include(FindSGIP)
    endif()
    set(RENDERLIB openglrender.a CACHE FILEPATH "Set of Rendering libraries for OpenGL-on build or dummy" FORCE)
  endif()
  if(USEOPENGLFLR)
    set(FLRRENDERLIB flrrender.a CACHE FILEPATH "Set of Flare-Rendering libraries for OpenGLFlare-on build or dummy" FORCE)
  endif()
  if(USEOPENGLSMOKE)
    set(SMOKERENDERLIB smokerender.a CACHE FILEPATH "Set of Smoke-Rendering libraries for OpenGLSmoke-on build or dummy" FORCE)
  endif()
endif()

if(USECUDA AND NOT ELVERSION STREQUAL "7")
  if(ELVERSION STREQUAL "6")
    set(CUDA_TOOLKIT_ROOT_DIR /usr/local/cuda CACHE PATH "The CUDA Toolkit Root Directory" FORCE)
  elseif(ELVERSION STREQUAL "5")
    set(CUDA_TOOLKIT_ROOT_DIR /usr/share/cuda CACHE PATH "The CUDA Toolkit Root Directory" FORCE)
  endif()
  set(CUDA_SDK_ROOT_DIR /usr/share/cuda CACHE PATH "The CUDA SDK Root Directory" FORCE)#deprecated by CUDA5; CUDA4 side-install provides it for EL6
  set(CUDA_FIND_REQUIRED TRUE)
  include(FindCUDA)
  if(DEBUG)
    set(CUDAFLAGSDEBUG "-g;-G")
  else()
    set(CUDAFLAGSDEBUG "-O3")
  endif()
  if(NOT ELVERSION STREQUAL "5")
    set(CUDA_NVCC_FLAGS "--compiler-options;-fno-strict-aliasing;${CUDAFLAGSDEBUG};-gencode=arch=compute_13,code=sm_13;-gencode=arch=compute_13,code=compute_13" CACHE STRING "CUDA NVCC Compiler Flags" FORCE)#must be semi-colon delimited; also, nvcc profiling flags are incompatible with architecture specification flags in all non-circuitous compiling and linking, so there is no profiling option here
  else()
    execute_process(COMMAND cmake -E create_symlink /usr/bin/g++44 ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/g++)
    execute_process(COMMAND cmake -E create_symlink /usr/bin/gcc44 ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/gcc)
    set(CUDA_NVCC_FLAGS "--compiler-options;-fno-strict-aliasing;${CUDAFLAGSDEBUG};-ccbin=${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY};-gencode=arch=compute_13,code=sm_13;-gencode=arch=compute_13,code=compute_13" CACHE STRING "CUDA NVCC Compiler Flags" FORCE)#must be semi-colon delimited; also, nvcc profiling flags are incompatible with architecture specification flags in all non-circuitous compiling and linking, so there is no profiling option here
  endif()
  set(CUDALIBS ${CUDA_CUDART_LIBRARY} ${CUDA_cufft_LIBRARY} ${CUDA_cublas_LIBRARY} -lm CACHE FILEPATH "Composite CUDA libraries for CUDA-on build or dummy" FORCE)
  add_library(cudautil.a STATIC IMPORTED)
  add_library(paramgl.a STATIC IMPORTED)
  add_library(rendercheckgl.a STATIC IMPORTED)
  if(DEBUG)
    set_property(TARGET cudautil.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/libcutil_x86_64D.a)
    set_property(TARGET paramgl.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/libparamgl_x86_64D.a)
    set_property(TARGET rendercheckgl.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/librendercheckgl_x86_64D.a)
  else()
    set_property(TARGET cudautil.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/libcutil_x86_64.a)
    set_property(TARGET paramgl.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/libparamgl_x86_64.a)
    set_property(TARGET rendercheckgl.a PROPERTY IMPORTED_LOCATION ${CUDA_SDK_ROOT_DIR}/C/lib/librendercheckgl_x86_64.a)
  endif()
  set(CUDAAUXLIBS cudautil.a paramgl.a rendercheckgl.a ${CUDA_CUDART_LIBRARY} CACHE FILEPATH "CUDA Auxiliary libraries for CUDA-on build or dummy" FORCE)
  set(RETLIB cudareticle.a ${CUDALIBS} cudautil.a CACHE FILEPATH "CUDA Reticle library for CUDA-on build or dummy" FORCE)
endif()

if(USEFLTS AND USECUDA)
#no find_requires since all we need are libraries and not includes
  include(FindTIFF)
  include(FindBZip2)
  if(CLASSED)
    include(FindFLTS)
  else()
    add_library(extflts.so SHARED IMPORTED)
    set_property(TARGET extflts.so PROPERTY IMPORTED_LOCATION ${FLTSDIR}/lib64/libflts.so)
    set(FLTS_LIBRARY extflts.so CACHE FILEPATH "The FLTS external library" FORCE)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(FLTS DEFAULT_MSG FLTS_LIBRARY)
  endif()
  set(FLTSLIB flts.a decoymanager.a ${FLTS_LIBRARY} ${CUDA_CUDART_LIBRARY} ${X11_X11_LIB} ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${TIFF_LIBRARY} ${BZIP2_LIBRARIES} CACHE FILEPATH "FLTS Libraries for FLTS-on build or dummy" FORCE)
endif()
#
#--------------------END CONFIGURATION---------------------

#-----------------BEGIN CUSTOM FUNCTIONS-------------------
#
#Custom Fortran Preprocessor Function: preprocess_fortran(outputfiles extrafppflags inputfiles)
#When calling "preprocess_fortran" within a local CMakeList, the first argument should be a variable which will store the output list of renamed or originally named source files.  This variable will be used for building libraries or executables later in the CMakeList.  The second argument should be extra Fortran preprocessor flags for that local CMakeList.  The second argument variable must be passed in as a single argument, but assigned within the CMakeList as an array of strings.  Failure to assign the argument variable internally as an array will lead to faulty define preprocessing, and failure to pass the array in as a single argument will cause a fatal configuration error. The third argument should be the full list of source files to be preprocessed.  This function treats each preprocessed Fortran file as a target with full support for automatic dependency scanning.  The preprocessed files are then the dependencies for the target objects which are built before the library link.

set(FPPEXEC /lib/cpp CACHE FILEPATH "Path to C Preprocessor" FORCE)
function(preprocess_fortran outputfiles extrafppflags)
#gfpp    set(${outputfiles} "${ARGN}" PARENT_SCOPE) #then skip below stuff
  #assemble include directories
  get_directory_property(includedirs INCLUDE_DIRECTORIES)
  set(includeflags)
  foreach(inc ${includedirs})
    set(includeflags ${includeflags} -I${inc})
  endforeach()
  #assemble universal defines
  get_directory_property(defines COMPILE_DEFINITIONS)
  set(defineflags)
  foreach(def ${defines})
    set(defineflags ${defineflags} -D${def})
  endforeach()
  #assemble aqua teen hunger force (needs to be updated to aqua unit patrol squad)
  set(srcs)
  foreach(fortranfile ${ARGN})
    #if the source file is not in the CURRENT_SOURCE_DIR, then we need to do path manipulation
    if(NOT IS_ABSOLUTE "${fortranfile}")
      get_filename_component(fortranfile "${fortranfile}" ABSOLUTE)
    endif()
    file(RELATIVE_PATH relpath "${CMAKE_CURRENT_SOURCE_DIR}" "${fortranfile}")
    #string split the file name and name the output file based on current name
    get_filename_component(filename "${relpath}" NAME_WE)
    get_filename_component(filepath "${relpath}" PATH)
    get_filename_component(fileext "${relpath}" EXT)
    set(outfile "${CMAKE_CURRENT_BINARY_DIR}/${filepath}/${filename}.tmp.f")
    #preprocess the Fortran source file and scan dependencies for each target
    add_custom_command(OUTPUT ${outfile}
                       #strip out comments
                       COMMAND grep -v \^[\^\#\ \t0-9@] ${fortranfile} > ${CMAKE_CURRENT_BINARY_DIR}/tmpfile
                       #convert Fortran-style includes to C-style includes
                       COMMAND sed -i -r "s/\^\\s+INCLUDE\\s+'?\"?(.*\\.[A-Za-z]*)'?\"?/\\#include \"\\1\"/I" ${CMAKE_CURRENT_BINARY_DIR}/tmpfile
                       COMMAND ${FPPEXEC} -P -traditional ${includeflags} ${defineflags} ${FPPFLAGS} ${extrafppflags} ${CMAKE_CURRENT_BINARY_DIR}/tmpfile > ${outfile}
                       MAIN_DEPENDENCY ${fortranfile}
                       IMPLICIT_DEPENDS C ${fortranfile}
                       VERBATIM)
    #keep a list of all the output preprocessed source file locations
    list(APPEND srcs "${outfile}")
  endforeach()
  #output all the preprocessed file locations as the first function argument so the local CMakeList knows where they are
  set(${outputfiles} "${srcs}" PARENT_SCOPE)
#gfpp  endif()
endfunction()

#Custom Ada Preprocessor Function: preprocess_ada(outputfiles appflags nobldfiles inputfiles)
#Read description of preprocess_fortran first.  Changes for preprocess_ada include an extra argument before the input preprocessor flags and the input source files.  The files in that argument are passed to preprocess_ada_nobuild.  Those files must be set as an array in the CMakeLists, but passed through as a single argument.  These files are primarily .ads files corresponding to .adb files.  They are not meant to be built, but rather preprocessed and construed as dependencies for the preprocessed .adb files.

set(APPEXEC /lib/cpp CACHE FILEPATH "Path to C Preprocessor" FORCE)
function(preprocess_ada outputfiles appflags nobldfiles)
  #preprocess ads files which are not to be linked into an ada library later
  #an execsrc will not have nobldfiles; also, just in case all the intended logic fails for preprocessed Ada executable source files, the first local include will be CMAKE_CURRENT_BINARY_DIR so that the generated link statement will always prefer the preprocessed source file over the non-preprocessed source via the -aI gathering in add_ada_executable
  if(NOT ${outputfiles} MATCHES "execsrc")
    preprocess_ada_nobuild("${appflags}" ${nobldfiles})
  endif()
  #assemble include directories
  get_directory_property(includedirs INCLUDE_DIRECTORIES)
  set(includeflags)
  foreach(inc ${includedirs})
    set(includeflags ${includeflags} -I${inc})
  endforeach()
  set(srcs)
  foreach(adafile ${ARGN})
    #if the source file is not in the source directory, then we need to do path manipulation
    if(NOT IS_ABSOLUTE "${adafile}")
      get_filename_component(adafile "${adafile}" ABSOLUTE)
    endif()
    file(RELATIVE_PATH relpath "${CMAKE_CURRENT_SOURCE_DIR}" "${adafile}")
    #string split the file name and name the output file based on current name
    get_filename_component(filename "${relpath}" NAME_WE)
    get_filename_component(filepath "${relpath}" PATH)
    get_filename_component(fileext "${relpath}" EXT)
    set(outfile "${CMAKE_CURRENT_BINARY_DIR}/${filepath}/${filename}${fileext}")
    #preprocess the Ada source file and scan dependencies for each target
    if(${fileext} MATCHES ".adb" AND NOT ${outputfiles} MATCHES "execsrc")
      add_custom_command(OUTPUT ${outfile}
                         COMMAND ${APPEXEC} -P -traditional ${includeflags} ${appflags} ${adafile} > ${outfile}
                         MAIN_DEPENDENCY ${adafile}
                         #list the preprocessed corresponding ads file as a dependency so it is preprocessed prior to the compilation of this adb file
                         DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${filepath}/${filename}.ads
                         IMPLICIT_DEPENDS C ${adafile}
                         VERBATIM)
    #this file is .ads and therefore has no preprocessed .ads dependency
    else()
      add_custom_command(OUTPUT ${outfile}
                         COMMAND ${APPEXEC} -P -traditional ${includeflags} ${appflags} ${adafile} > ${outfile}
                         MAIN_DEPENDENCY ${adafile}
                         IMPLICIT_DEPENDS C ${adafile}
                         VERBATIM)
    endif()
    #keep a list of all the output preprocessed source file locations (nobldfiles not listed here as they will not be compiled)
    list(APPEND srcs "${outfile}")
  endforeach()
  #output all the preprocessed file locations as the first function argument so the local CMakeList knows where they are
  set(${outputfiles} "${srcs}" PARENT_SCOPE)
endfunction()

#Custom Ada Preprocessor Function: preprocess_ada_nobuild(appflags nobldfiles)
#A stripped down version of preprocess_ada for preprocessing .ads files which are dependencies of preprocessed .adb files.  All files which are passed as "nobldfiles" into preprocess_ada will be configured through this function, but only actually preprocessed if preprocess_ada determines them as dependencies.  This function should never be called directly from a CMakeList.

function(preprocess_ada_nobuild appflags)
  foreach(adafile ${ARGN})
    #if the source file is not in the source directory, then we need to do path manipulation
    if(NOT IS_ABSOLUTE "${adafile}")
      get_filename_component(adafile "${adafile}" ABSOLUTE)
    endif()
    file(RELATIVE_PATH relpath "${CMAKE_CURRENT_SOURCE_DIR}" "${adafile}")
    #string split the file name and name the output file based on current name
    get_filename_component(filename "${relpath}" NAME_WE)
    get_filename_component(filepath "${relpath}" PATH)
    get_filename_component(fileext "${relpath}" EXT)
    set(outfile "${CMAKE_CURRENT_BINARY_DIR}/${filepath}/${filename}${fileext}")
    #preprocess the Ada source file and scan dependencies for each target
    add_custom_command(OUTPUT ${outfile}
                       COMMAND ${APPEXEC} -P -traditional ${appflags} ${adafile} > ${outfile}
                       MAIN_DEPENDENCY ${adafile}
                       IMPLICIT_DEPENDS C ${adafile}
                       VERBATIM)
  endforeach()
endfunction()

#Custom Static Library Function: add_static_library(target libname inputfiles)
#This function is written primarily to remove the "lib" prefix when linking a library that we build in PROJECT.  CMake normally has executables link to libraries with the "lib" prefix and ".a." or ".so" suffixes EXCEPT that CMAKE_STATIC_LIBRARY_PREFIX is forced to "" so we avoid this potential trap. Also, CMake demands each target be uniquely named, so we have differently named targets that still have the same output filename to be consistent with current PROJECT naming conventions.  The library SUFFIX is now handled similarly to the PREFIX.  All libraries are also installed to the library install directory for non-Debug configurations.

function(add_static_library target libname)
  add_library(${target} STATIC ${ARGN})
  set_target_properties(${target} PROPERTIES PREFIX "" SUFFIX "" OUTPUT_NAME ${libname})
endfunction()

#Custom CUDA Static Library Function: add_static_cuda_library(target libname inputfiles)
#Same as above add_static_library function but passes in arguments to cuda_add_library so that NVCC acts appropriately on the .cu files.

function(add_static_cuda_library target libname)
  cuda_add_library(${target} STATIC ${ARGN})
  set_target_properties(${target} PROPERTIES PREFIX "" SUFFIX "" OUTPUT_NAME ${libname})
endfunction()

#Custom Shared Library Function: add_shared_library(target libname inputfiles)
#Same as above add_static_library function but AR/RANLIB establish the library as a shared object for dynamic linking.

function(add_shared_library target libname)
  add_library(${target} SHARED ${ARGN})
  string(REPLACE ".so" "${CONFIGNAME}.so" libname ${libname})
  set_target_properties(${target} PROPERTIES PREFIX "" SUFFIX "" OUTPUT_NAME ${libname})
  install(TARGETS ${target} DESTINATION lib)
endfunction()

#Custom CUDA Shared Library Function: add_shared_cuda_library(target libname inputfiles)
#Combination of add_shared_library and add_static_cuda_library functions towards the obvious end.

function(add_shared_cuda_library target libname)
  cuda_add_library(${target} SHARED ${ARGN})
  string(REPLACE ".so" "${CONFIGNAME}.so" libname ${libname})
  set_target_properties(${target} PROPERTIES PREFIX "" SUFFIX "" OUTPUT_NAME ${libname})
  install(TARGETS ${target} DESTINATION lib)
endfunction()

#Custom FLTS Plugin Function: add_flts_plugin(target libname inputfiles)
#Same as add_shared_library function but also installs the target inside a "flts" subdirectory located within the library install directory.

function(add_flts_plugin target libname)
  add_shared_library(${target} ${libname} ${ARGN})
  install(TARGETS ${target} DESTINATION lib/flts)
endfunction()

#Custom Add Ada Executable Function: add_ada_excutable(target source-files) (major update per Ada toolchain upgrade July 25 2012)
#This function exists to give the user a comfortable add_executable syntax while now providing a simplified and streamlined backdoor to gnatmake.  The provided target name argument is still used to identify the primary source file (<TARGET_BASE>.adb), but the executable argument objects are now compiled in the compile step and found during the link step (-aO<OBJECT_DIR>/-aL<OBJECT_DIR>). Hypothetically, if one knew all the source files that gnatmake required for each executable and passed them as arguments to add_ada_executable ${ARGN}, all the side compilations in gnatmake could be performed during the compile step.  Gnatmake's bind/link cannot be split apart since gnatbind would need to access .ali files in other directories' <OBJECT_DIR>, which is either impossible or difficult beyond any solutions I can conceive of for CMake intrinsics.  Under the alternative method of providing all necessary source files to add_ada_executable ${ARGN}, these .ali files would be in <OBJECT_DIR> and the bound source files would be accessed via the include gathering.  The main purpose of this function now is to gather the includes and transform them into -aI flags for gnatmake.  No library link or preprocessor hacks/kludges are necessary now.  A risk of adding -I- to the gnatmake flags could be attempted in the future to completely block potential compilations which are actually unnecessary.

function(add_ada_executable target)
  add_executable(${target} ${ARGN})
  get_directory_property(includedirs INCLUDE_DIRECTORIES)
  set(includeflags)
  foreach(inc ${includedirs})
    set(includeflags "${includeflags} -aI${inc}")
  endforeach()
  set_target_properties(${target} PROPERTIES LINK_FLAGS "${includeflags} -aI${CMAKE_CURRENT_SOURCE_DIR}")
endfunction()

#Custom Install Scripts Function: script_install(scripts)
#This function installs scripts.  The scripts to be installed are the only arguments to be passed into this function.

function(script_install)
  foreach(script ${ARGN})
    if(${script} MATCHES ".sh")
      STRING(REPLACE ".sh" "" scriptout ${script})
    else()
      set(scriptout ${script})
    endif()
    #need to copy installed scripts to binary directory for production builds so that the specgenerator parser can find the installed scripts and generate the correct spec file
    if(NOT DEBUG)
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/${script} ${CMAKE_CURRENT_BINARY_DIR}/${scriptout})
    endif()
    install(PROGRAMS ${script} DESTINATION bin${CONFIGNAME} RENAME ${scriptout})
  endforeach()
endfunction()

#Overload Add Executable Function: add_executable(target sources)
#This function overload makes every target executable a target for make install.

function(add_executable target)
  _add_executable(${target} ${ARGN})
  get_filename_component(extstrip "${target}" NAME_WE)
  install(TARGETS ${target} DESTINATION bin${CONFIGNAME})
  set_target_properties(${target} PROPERTIES OUTPUT_NAME ${extstrip} BUILD_WITH_INSTALL_RPATH TRUE)
endfunction()
#
#-------------------END CUSTOM FUNCTIONS-------------------

#------------------BEGIN ACTUAL CMAKELIST------------------
#
cmake_minimum_required(VERSION 2.8.7)
project(PROJECT)
add_subdirectory(sap)
if(USESENSE OR PROJECTUNIFIEDISE)
  add_subdirectory(l)
endif()
add_subdirectory(u)
if(USESIL)
  add_subdirectory(s)
endif()
if(USEOPENGL)
  if(USEOPENGLRENDER)
    add_subdirectory(opengllib)
    add_subdirectory(t)
  endif()
  if(USEOPENGLFLR)
    add_subdirectory(opengl_f)
  endif()
  if(USEOPENGLSMOKE)
    add_subdirectory(opengl_s)
  endif()
  add_subdirectory(s)
endif()
if(USECUDA)
  add_subdirectory(cudalib)
  if(USEFLTS)
    add_subdirectory(fi)
  endif()
endif()
add_subdirectory(s)
add_subdirectory(s)
add_subdirectory(v)
add_subdirectory(at)
if(USESENSE)
  add_subdirectory(s)
  add_subdirectory(m)
  add_subdirectory(r)
  add_subdirectory(i)
  if(CLASSED)
    add_subdirectory(v)
  endif()
endif()
if(CLASSED)
  add_subdirectory(m)
  add_subdirectory(d)
  add_subdirectory(v)
  add_subdirectory(a)
endif()
add_subdirectory(e)
add_subdirectory(d)
add_subdirectory(d)
add_subdirectory(p)
add_subdirectory(m)
if(USESAIL)
  add_subdirectory(s)
endif()
if(CLASSED)
  add_subdirectory(m)
  add_subdirectory(gd)
  add_subdirectory(nti)
endif()
if(PROJECTUNIFIEDISE AND PROPRIETARY)
  if(USEFLAME AND CLASSED)
    add_subdirectory(f)
  endif()
  add_subdirectory(si)
  add_subdirectory(t)
  add_subdirectory(fdc)
  add_subdirectory(s)
  add_subdirectory(mi)
  add_subdirectory(it)
  add_subdirectory(ip)
  add_subdirectory(r)
  add_subdirectory(mtp)
  add_subdirectory(at)
  add_subdirectory(oit)
endif()
add_subdirectory(x)
add_subdirectory(x)
#
#-------------------END ACTUAL CMAKELIST-------------------
