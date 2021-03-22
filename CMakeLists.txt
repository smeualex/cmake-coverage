cmake_minimum_required(VERSION 3.11)

project(coverage-test VERSION 1.0.00 LANGUAGES CXX)

###############################################################################
# Build options
###############################################################################
option( LOG_CMAKE_VARIABLES "Log cmake variables"                         OFF )
option( BUILD_TESTS         "Build unit tests."                           OFF )
option( RUN_ALL_TESTS       "Run all tests sepparately"                   OFF )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
if(BUILD_TESTS)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/extern/libs/prebuilt/catch2/lib/cmake/Catch2")
endif()
if(LOG_CMAKE_VARIABLES)
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_MODULE_PATH              = " ${CMAKE_MODULE_PATH})
endif()

enable_testing()

add_subdirectory(lib1)
add_subdirectory(lib2)
add_subdirectory(main-exe)