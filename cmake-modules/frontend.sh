#!/bin/bash

######################################################
#PROJECT directories in your working copy (CONFIGNAME string appended to bld/bin)
SRCDIR=src
CONFIGNAME=""
#DEBUG Compile Flags (else Optimization Flags)
DEBUG=TRUE
#Configure only; do not build or install
NOBUILD=FALSE
#Using GNU 4.8.x for C/C++/Fortran/Ada on EL6; else 4.4.7 (warning: parts of PROJECT not up to G48 standard)
GCC48=FALSE
#Code optimization profiling enabled for C/C++/Fortran
PROFILE=FALSE
#Newer CMake to be used than group baseline 2.8.7 (must be EL6; forced option on EL7)
CMAKEDEV=FALSE
#User options for components included in the build
USEOPENGL=TRUE #OpenGL
USEOPENGLRENDER=TRUE #OpenGLRender (must also be OPENGL)
USEOPENGLFLR=TRUE #OpenGLFlrRender (must also be OPENGL)
USEOPENGLSMOKE=FALSE #OpenGLSmoke (must also be OPENGL)
USESGIP=FALSE #Proprietary external OpenGL rendering code (must also be OPENGLRENDER)
USECUDA=TRUE #CUDA
USEFLAME=TRUE #Flame (must also be PROPRIETARY, PROJECTUNIFIEDISAMS, and CLASSIFIED)
USESMOKE=TRUE #Smoke
USEOCEAN=TRUE #Ocean
USEMODTRAN5=TRUE #Modtran5 vs. Modtran4 (only matters for PROPRIETARY)
USESENSE=TRUE #non-PROJECTUNIFIEDISAMS Sense
USESIL=FALSE #SIL (non-E2E SIL currently unsupported; leave FALSE)
USEFLTS=FALSE #FLTS Proprietary Software (must also be CUDA)
USESAIL=FALSE #SAIL IPC Software
PROPRIETARY=TRUE #Proprietary Software Included (Modtran and Flame)
PROJECTUNIFIEDISAMS=TRUE #ISAMS components included (must also be PROPRIETARY)
CLASSED=FALSE #Classed PROJECT components included
######################################################

######################################################
PROJECTDIR=`cd ../; pwd`
ELVERSION=`lsb_release -rs | awk -F . '{print $1}'`
if [ "$ELVERSION" == "7" ]; then
  GCCVERSION=`ls /usr/lib/gcc/x86_64-redhat-linux/ | tail -n 1`
  CMAKEDEV=TRUE
elif [ "$ELVERSION" == "6" ]; then
  if [ "$GCC48" == "TRUE" ]; then
    GCCVERSION=`ls /usr/lib/gcc/x86_64-redhat-linux7E/ | tail -n 1`
  else
    GCCVERSION=`ls /usr/lib/gcc/x86_64-redhat-linux/ | tail -n 1`
  fi
elif [ "$ELVERSION" == "5" ]; then
  GCCVERSION=`ls /usr/lib/gcc/x86_64-redhat-linux6E/ | tail -n 1`
else
  echo "NOT ENTERPRISE LINUX 5, 6, or 7 SYSTEM!  PROJECT IS NOT SUPPORTED!"
fi
if [[ "$CMAKEDEV" == "TRUE" && "$ELVERSION" == "6" ]]; then
  CMAKEEXEC=/usr/bin/cmake28
else
  CMAKEEXEC=/usr/bin/cmake
fi

mkdir -p ../bld${CONFIGNAME}
if [ "$USEFLTS" == "TRUE" ]; then
  mkdir -p ../lib/flts
else
  mkdir -p ../lib
fi
mkdir -p ../bin${CONFIGNAME}
cd ../bld${CONFIGNAME}
rm -f CMakeCache.txt

echo "set(PROJECTDIR \"${PROJECTDIR}\" CACHE PATH \"PROJECT Directory\" FORCE)
set(SRCDIR \"${SRCDIR}\" CACHE PATH \"Source Directory\" FORCE)
set(CONFIGNAME \"${CONFIGNAME}\" CACHE PATH \"Configuration Suffix Identifier\" FORCE)
set(DEBUG ${DEBUG} CACHE BOOL \"Debug Mode\" FORCE)
set(GCC48 \"${GCC48}\" CACHE BOOL \"GNU C/C++/Fortran version 4.8.x\" FORCE)
set(GCCVERSION \"${GCCVERSION}\" CACHE STRING \"GCC Version\" FORCE)
set(PROFILE ${PROFILE} CACHE BOOL \"Profile Option\" FORCE)
set(ELVERSION ${ELVERSION} CACHE BOOL \"Enterprise Linux Major Version\" FORCE)
set(CMAKEDEV ${CMAKEDEV} CACHE BOOL \"CMake 2.8.x Official Dev Version\" FORCE)
set(USEOPENGL ${USEOPENGL} CACHE BOOL \"OpenGL Included\" FORCE)
set(USEOPENGLRENDER ${USEOPENGLRENDER} CACHE BOOL \"OpenGLRenderer Included\" FORCE)
set(USEOPENGLFLR ${USEOPENGLFLR} CACHE BOOL \"OpenGLFlrRenderer Included\" FORCE)
set(USEOPENGLSMOKE ${USEOPENGLSMOKE} CACHE BOOL \"OpenGLSmokeRenderer Included\" FORCE)
set(USESGIP ${USESGIP} CACHE BOOL \"External OpenGLTerrainRenderer Included\" FORCE)
set(USECUDA ${USECUDA} CACHE BOOL \"CUDA Included\" FORCE)
set(USEFLAME ${USEFLAME} CACHE BOOL \"Flame Included\" FORCE)
set(USESMOKE ${USESMOKE} CACHE BOOL \"Smoke Included\" FORCE)
set(USEOCEAN ${USEOCEAN} CACHE BOOL \"Ocean Included\" FORCE)
set(USEMODTRAN5 ${USEMODTRAN5} CACHE BOOL \"Modtran5 Included\" FORCE)
set(USESENSE ${USESENSE} CACHE BOOL \"Sense Included\" FORCE)
set(USESIL ${USESIL} CACHE BOOL \"SIL Included\" FORCE)
set(USEFLTS ${USEFLTS} CACHE BOOL \"FLTS Included\" FORCE)
set(USESAIL ${USESAIL} CACHE BOOL \"SAIL Included\" FORCE)
set(PROPRIETARY ${PROPRIETARY} CACHE BOOL \"Proprietary Included\" FORCE)
set(PROJECTUNIFIEDISAMS ${PROJECTUNIFIEDISAMS} CACHE BOOL \"ISAMS Included\" FORCE)
set(CLASSED ${CLASSIFIED} CACHE BOOL \"Classed Components Included\" FORCE)" > PROJECTConfigure.cmake

${CMAKEEXEC} -C PROJECTConfigure.cmake ../${SRCDIR}
if [ "$NOBUILD" == "FALSE" ]; then
  make install -k
fi
######################################################
