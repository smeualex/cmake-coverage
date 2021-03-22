cmake_minimum_required(VERSION 3.11)

project(lib2-test LANGUAGES CXX)

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

    # add static dependencies
    target_link_libraries(${PROJECT_NAME} PRIVATE
        lib2
        Catch2::Catch2
    )

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