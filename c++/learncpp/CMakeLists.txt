cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_STANDARD 11 CACHE STRING "C++11 Standard" FORCE)

enable_language(CXX)

add_subdirectory(1.12)
add_subdirectory(2.10.3)
add_subdirectory(2.10.4)
add_subdirectory(4.4b)
add_subdirectory(4.7.1)
add_subdirectory(4.7.2)
add_subdirectory(4.x)
