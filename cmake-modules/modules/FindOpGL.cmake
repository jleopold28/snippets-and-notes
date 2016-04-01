# very heavily modified from archaic FindOpenGL.cmake to avoid unwanted mesa

# - Try to find OpenGL
# Once done this will define
#  
#  OPENGL_FOUND        - system has OpenGL
#  OPENGL_INCLUDE_DIR  - the GL include directory
#  OPENGL_LIBRARIES    - Link these to use OpenGL and GLU
#   
# If you want to use just GL you can use these values
#  OPENGL_gl_LIBRARY   - Path to OpenGL Library
#  OPENGL_glu_LIBRARY  - Path to GLU Library
#

IF(OPENGL_INCLUDE_DIR)
  #already in cache
  SET(OPENGL_FIND_QUIETLY TRUE)
ENDIF(OPENGL_INCLUDE_DIR)

FIND_PATH(OPENGL_INCLUDE_DIR
  NAMES GL/gl.h
  PATHS /usr/include)

FIND_PATH(OPENGL_xmesa_INCLUDE_DIR 
  NAMES GL/xmesa.h
  PATHS /usr/include)

FIND_LIBRARY(OPENGL_gl_LIBRARY
  NAMES GL MesaGL
  PATHS /usr/lib64/nvidia
        /usr/lib64
        /usr/lib)

FIND_LIBRARY(OPENGL_glu_LIBRARY
  NAMES GLU MesaGLU
  PATHS /usr/lib64/nvidia
        /usr/lib64
        /usr/lib)

SET(OPENGL_LIBRARIES ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY})

IF(OPENGL_INCLUDE_DIR AND OPENGL_gl_LIBRARY AND OPENGL_glu_LIBRARY)
  SET(OpenGL_FOUND TRUE)
  SET(OPENGL_LIBRARY_DIR ${OPENGL_gl_LIBRARY})
ELSE(OPENGL_INCLUDE_DIR AND OPENGL_gl_LIBRARY AND OPENGL_glu_LIBRARY)
  SET(OpenGL_FOUND FALSE)
  SET(OPENGL_LIBRARY_DIR)
ENDIF(OPENGL_INCLUDE_DIR AND OPENGL_gl_LIBRARY AND OPENGL_glu_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set OPENGL_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenGL DEFAULT_MSG OPENGL_LIBRARIES)

MARK_AS_ADVANCED(
  OPENGL_INCLUDE_DIR
  OPENGL_xmesa_INCLUDE_DIR
  OPENGL_gl_LIBRARY
  OPENGL_glu_LIBRARY)
