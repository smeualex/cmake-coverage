# cmake-coverage

A simple-ish project using CMake and gcov to generate coverage reports.
The sub-projects are simply named `lib1`, `lib2` and `main-exe` for the sake of clarity.

External libraries\modules used:
- Catch2 - https://github.com/catchorg/Catch2
- cmake-coverage.cmake module https://github.com/StableCoder/cmake-scripts


[![CI](https://github.com/smeualex/cmake-coverage/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/smeualex/cmake-coverage/actions/workflows/build.yml)

## Project Structure

```
+---.github
|   \---workflows                       -> github workflows .yml files
+---.vagrant                            -> generated after running "vagrant up"
+---.vscode                             -> VsCode's stuff
+---build                               -> build directory if using the build scripts
|   +---Linux-i686                      -> Linux build
|   |   \---Debug
|   |       \---ccov                    -> coverage data and html reports
|   \---Win32                           -> Win32 build
|       \---Debug
+---cmake                               -> cmake modules
+---extern                              -> extern dependencies (prebuilt, or archives, etc)
|   \---libs
|       \---prebuilt
|           \---catch2
+---lib1                                -> lib1 sub-project
|   +---src
|   \---test
+---lib2                                -> lib2 sub-project
|   +---src
|   \---test
+---main-exe                            -> the main executable
|   \---src
\---scripts                             -> all kind of scripts: build, installing stuff in vagrant box
    \---vagrant
        \---provision
            \---debian

```

## CMake Build
The "main" CMake file is the one located in the root directory. 
It defines several cmake options and, in the end, will include all the other subdirectories into the build.

In each project the CMakeFiles.txt are as follows:
```
+---lib1
    +---src
    |
    +---test
    |   \---CMakeLists.txt      -> build the test code (only if BUILD_TEST is ON)
    \---CMakeLists.txt          -> build the code found in src and includes the test subdirectory
```

## Getting coverage reports

THIS APPROACH ONLY WORKS ON LINUX, as it is using `gcov`.

Usually there are the "standard" flags to be set to get the coverage instrumentation:
    
    ```Cmake
    SET(CMAKE_CXX_FLAGS "-g -O0 --coverage -fprofile-arcs -ftest-coverage")
    ```

While there is no real problem with this approach, it can get quite ugly in a complex situation.


A better approach is to use a ready-made CMake module, like `code-coverage.cmake`

1. Get it like this into any desired location:
    ``` bash
    wget https://raw.githubusercontent.com/bilke/cmake-modules/master/CodeCoverage.cmake
    ```
2. Add the path to its location to `CMAKE_MODULE_PATH`
3. The file has some examples to get you going

### Basic Usage

Getting coverage reports for executables is pretty straight forward, following the examples:

1  Add the `code-coverage.cmake` module to `CMAKE_MODULE_PATH` variable
    
    ```Cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
    ```

2. Include the `code-coverage.cmake` module
    
    ```Cmake
    include(code-coverage)
    ```

3. Enable coverage by using one of the several provided functions
    
    ```Cmake
    # Adds instrumentation to all targets
    add_code_coverage()
    
    # or

    # Adds the 'ccov-all' target set and sets it to exclude all files in test/ folders.
    add_code_coverage_all_targets(EXCLUDE test/*) 

    # As a library target, adds coverage instrumentation but no targets.
    target_code_coverage(theLib)

    # or

    # As an executable target, the reports will exclude the non-covered.cpp file,
    # and any files in a test/ folder.
    target_code_coverage(theExe EXCLUDE non_covered.cpp test/*) 
    ```

### What works and what doesn't work right out of the box

Getting coverage for an executable works fine.

Getting coverage data for a static library, is a bit of a hassle (it was to be expected :) ).

Even though in the examples the file is included and the functions are called directly I found it has some problems when you use the same CMake files to build a `Release` without code coverage.

_By `Release` build in terms of G++ I mean an executable with its debug symbols stripped and with optimizations turned on_

### How it's used in this project (and how I got coverage from a static library)

The only way I could get coverage report from a static library was to include it whole in the executable by using `-Wl,--whole-archive`.
This was a bit of a problem - as far as I know CMake does not support it "natively" - when set all the following libraries are included as "whole" untill `-Wl,--no-whole-archive` is encountered.
This meant that I had to include my static library between these 2 linker flags.

The solution is a bit hacky, but it works, so I'm fine with it.

If we're running a coverage build, link the library "manually" by setting `target_link_options` between the 2 linker flas; if not, use the normal "CMakey" way; then continue by adding the rest of the dependencies.

```CMake
if(CODE_COVERAGE)
    target_link_options(${PROJECT_NAME} PRIVATE 
        -Wl,--whole-archive $<TARGET_FILE:lib1> -Wl,--no-whole-archive
    )
else()
    target_link_libraries(${PROJECT_NAME} PRIVATE
        lib1
    )
endif()
```


#### /CMakeLists.txt

```Cmake
# add cmake modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

...

if(CODE_COVERAGE)
    include(code-coverage)
    add_code_coverage_all_targets(
        EXCLUDE ${CMAKE_SOURCE_DIR}/extern/libs/prebuilt/catch2/include/* /usr/include/c++/* /usr/include/i386-linux-gnu/c++/*
    )
endif()
```

#### /lib1/CMakeLists.txt

```CMake
...
if(CODE_COVERAGE)
    target_code_coverage(${PROJECT_NAME} ALL)
endif()
...
```

#### /lib1/test/CMakeLists.txt

```CMake
if(CODE_COVERAGE)
    # https://stackoverflow.com/questions/38107459/generating-test-coverage-of-c-static-library-as-called-by-separate-test-classe
    # https://stackoverflow.com/questions/17949384/link-issue-with-whole-archive-no-whole-archive-options
    #
    #   add the whole static library to be visible by gcov
    #   $<TARGET_FILE:lib1> generator expression evaluates to the full path 
    #                       of the binary produced by the targed `lib1`
    #
    target_link_options(${PROJECT_NAME} PRIVATE 
        -Wl,--whole-archive $<TARGET_FILE:lib1> -Wl,--no-whole-archive
    )
else()
    target_link_libraries(${PROJECT_NAME} PRIVATE
        lib1
    )
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE
    Catch2::Catch2
)

###############################################################################
# Code coverage instrumentation
###############################################################################
if(CODE_COVERAGE)
    target_code_coverage(${PROJECT_NAME} ALL
        EXCLUDE ${CMAKE_SOURCE_DIR}/extern/libs/prebuilt/catch2/include/*
    )
endif()

###############################################################################
# CTEST
###############################################################################
include(CTest)
include(Catch)
catch_discover_tests(${PROJECT_NAME})
```