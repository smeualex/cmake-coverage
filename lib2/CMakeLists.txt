cmake_minimum_required(VERSION 3.11)

project(lib2 LANGUAGES CXX)

###############################################################################
# set sources
###############################################################################
file(GLOB_RECURSE ALL_SOURCES
    src/*.cpp
    src/*.h
)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/src" FILES ${ALL_SOURCES})

# build main static library
add_library(${PROJECT_NAME} STATIC ${ALL_SOURCES})

###############################################################################
# Code coverage instrumentation
###############################################################################
if(CODE_COVERAGE)
    target_code_coverage(${PROJECT_NAME} ALL)
endif()

target_include_directories(${PROJECT_NAME} PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}/src
)

add_subdirectory(test)
