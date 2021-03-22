cmake_minimum_required(VERSION 3.11)

project(coverage-test VERSION 1.0.00 LANGUAGES CXX)


list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
if(LOG_CMAKE_VARIABLES)
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_MODULE_PATH              = " ${CMAKE_MODULE_PATH})
endif()

enable_testing()

add_subdirectory(lib1)
add_subdirectory(lib2)
add_subdirectory(main-exe)