cmake_minimum_required(VERSION 3.11)

project(lib1-test LANGUAGES CXX)

###############################################################################
# TEST BUILD
###############################################################################
if(BUILD_TESTS)
    find_package(Catch2 REQUIRED
        HINTS ${CMAKE_SOURCE_DIR}/extern/libs/prebuilt/catch2/lib/cmake/Catch2
    )

    # add sources
    file(GLOB_RECURSE TEST_SOURCES
        *.cpp
        *.h
    )

    # create the source group for IDE
    source_group(TREE 
        "${CMAKE_CURRENT_SOURCE_DIR}" 
        FILES ${TEST_SOURCES}
    )

    # test executable
    add_executable(${PROJECT_NAME}
        ${TEST_SOURCES}
    )

    ###############################################################################
    # add static dependencies
    ###############################################################################
    if(CODE_COVERAGE)
        # https://stackoverflow.com/questions/38107459/generating-test-coverage-of-c-static-library-as-called-by-separate-test-classe
        # https://stackoverflow.com/questions/17949384/link-issue-with-whole-archive-no-whole-archive-options
        #
        #   add the whole static library to be visible by gcov
        #   $<TARGET_FILE:lib1> generator expression evaluates to the full path of the binary produced by the targed `lib1`
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
            EXCLUDE /vagrant/extern/libs/prebuilt/catch2/include/*
        )
    endif()

     # include directories
    target_include_directories(${PROJECT_NAME} PRIVATE
        ../src
        .
    )

    ###############################################################################
    # CTEST
    ###############################################################################
    include(CTest)
    include(Catch)
    catch_discover_tests(${PROJECT_NAME})
    if(RUN_ALL_TESTS)
        add_test(NAME RunAllTests 
                COMMAND $<TARGET_FILE:${PROJECT_NAME}> -s)
    endif()
endif()