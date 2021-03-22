cmake_minimum_required(VERSION 3.11)

project(main-exe LANGUAGES CXX)

###############################################################################
# set sources
###############################################################################
file(GLOB_RECURSE ALL_SOURCES
    src/*.cpp
    src/*.h
)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/src" FILES ${ALL_SOURCES})

add_executable(${PROJECT_NAME} ${ALL_SOURCES})
 
target_link_libraries(${PROJECT_NAME} PRIVATE
    lib1
    lib2
)