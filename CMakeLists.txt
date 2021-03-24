cmake_minimum_required(VERSION 3.11)

project(coverage-test VERSION 1.0.01 LANGUAGES CXX)

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
    message(STATUS " ${PROJECT_NAME}  |  ---------------------------------------------------------------------")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> GENERAL VARIABLES OUTPUT <<<<<")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> ")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> project: ${PROJECT_NAME} ")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> version: ${PROJECT_VERSION} ")
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    PROJECT_BINARY_DIR              = " ${PROJECT_BINARY_DIR})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    GLOBAL_OUTPUT_PATH              = " ${GLOBAL_OUTPUT_PATH})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_SOURCE_DIR                = " ${CMAKE_SOURCE_DIR})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_RUNTIME_OUTPUT_DIRECTORY  = " ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_LIBRARY_OUTPUT_DIRECTORY  = " ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_ARCHIVE_OUTPUT_DIRECTORY  = " ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})
    message(STATUS " ${PROJECT_NAME}  |  >>>>> ")
    message(STATUS " ${PROJECT_NAME}  |  ---------------------------------------------------------------------")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> OS SPECIFIC VARIABLES")
    message(STATUS " ${PROJECT_NAME}  |  >>>>> ")
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_STATIC_LIBRARY_PREFIX            = " ${CMAKE_STATIC_LIBRARY_PREFIX})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_STATIC_LIBRARY_SUFFIX            = " ${CMAKE_STATIC_LIBRARY_SUFFIX})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_SHARED_LIBRARY_PREFIX            = " ${CMAKE_SHARED_LIBRARY_PREFIX})
    message(STATUS " ${PROJECT_NAME}  |  >>>>>    CMAKE_SHARED_LIBRARY_SUFFIX            = " ${CMAKE_SHARED_LIBRARY_SUFFIX})
    message(STATUS " ${PROJECT_NAME}  |  >>>>> ")
    message(STATUS " ${PROJECT_NAME}  |  ---------------------------------------------------------------------")
endif()

if(CODE_COVERAGE)
    include(code-coverage)
    add_code_coverage_all_targets(
        EXCLUDE ${CMAKE_SOURCE_DIR}/extern/libs/prebuilt/catch2/include/* /usr/include/c++/* /usr/include/i386-linux-gnu/c++/*
    )
endif()

enable_testing()

add_subdirectory(lib1)
add_subdirectory(lib2)
add_subdirectory(main-exe)

# again a comment to test GPG key
# aaaand a new comment
