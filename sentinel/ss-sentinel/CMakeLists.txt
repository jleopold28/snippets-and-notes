# Minimum CMake required
cmake_minimum_required(VERSION 2.8)

# Project
project(SSSentinel CXX)

# Protobuf
set(protobuf_MODULE_COMPATIBLE TRUE)
find_package(protobuf CONFIG REQUIRED)
message(STATUS "Using protobuf ${protobuf_VERSION}")

# gRPC
find_package(gRPC CONFIG REQUIRED)
message(STATUS "Using gRPC ${gRPC_VERSION}")

# gRPC C++ plugin
get_target_property(gRPC_CPP_PLUGIN_EXECUTABLE gRPC::grpc_cpp_plugin IMPORTED_LOCATION_RELEASE)

# Proto file
get_filename_component(sent_proto "sentinel.proto" ABSOLUTE)
get_filename_component(sent_proto "${sent_proto}" PATH)

# Generated sources
protobuf_generate_cpp(sent_proto_srcs sent_proto_hdrs "${sent_proto}")
set(sent_grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/sentinel.grpc.pb.cc")
set(sent_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/sentinel.grpc.pb.h")
add_custom_command(
  OUTPUT "${sent_grpc_srcs}" "${sent_grpc_hdrs}"
  COMMAND protobuf::protoc
  ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}" -I "${sent_proto_path}" --plugin=protoc-gen-grpc="${gRPC_CPP_PLUGIN_EXECUTABLE}" "${sent_proto}"
  DEPENDS "${sent_proto}")

# Generated include directory
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

# Targets greeter_[async_](client|server)
foreach(_target sent_client sent_server sent_async_client sent_async_server)
  add_executable(${_target}
    "${_target}.cc"
    ${sent_proto_srcs}
    ${sent_grpc_srcs})
  target_link_libraries(${_target}
    protobuf::libprotobuf
    gRPC::grpc++_unsecure)
endforeach()
