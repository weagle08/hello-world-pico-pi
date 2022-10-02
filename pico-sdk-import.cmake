# This is a copy of <pico-sdk_PATH>/external/pico-sdk_import.cmake

# This can be dropped into an external project to help locate this SDK
# It should be include()ed prior to project()

if(DEFINED ENV{pico-sdk_PATH} AND(NOT pico-sdk_PATH))
    set(pico-sdk_PATH $ENV{pico-sdk_PATH})
    message("Using pico-sdk_PATH from environment ('${pico-sdk_PATH}')")
endif()

if(DEFINED ENV{pico-sdk_FETCH_FROM_GIT} AND(NOT pico-sdk_FETCH_FROM_GIT))
    set(pico-sdk_FETCH_FROM_GIT $ENV{pico-sdk_FETCH_FROM_GIT})
    message("Using pico-sdk_FETCH_FROM_GIT from environment ('${pico-sdk_FETCH_FROM_GIT}')")
endif()

if(DEFINED ENV{pico-sdk_FETCH_FROM_GIT_PATH} AND(NOT pico-sdk_FETCH_FROM_GIT_PATH))
    set(pico-sdk_FETCH_FROM_GIT_PATH $ENV{pico-sdk_FETCH_FROM_GIT_PATH})
    message("Using pico-sdk_FETCH_FROM_GIT_PATH from environment ('${pico-sdk_FETCH_FROM_GIT_PATH}')")
endif()

set(pico-sdk_PATH "${pico-sdk_PATH}" CACHE PATH "Path to the Raspberry Pi Pico SDK")
set(pico-sdk_FETCH_FROM_GIT "${pico-sdk_FETCH_FROM_GIT}" CACHE BOOL "Set to ON to fetch copy of SDK from git if not otherwise locatable")
set(pico-sdk_FETCH_FROM_GIT_PATH "${pico-sdk_FETCH_FROM_GIT_PATH}" CACHE FILEPATH "location to download SDK")

if(NOT pico-sdk_PATH)
    set(FETCHCONTENT_BASE_DIR_SAVE ${FETCHCONTENT_BASE_DIR})

    if(pico-sdk_FETCH_FROM_GIT_PATH)
        get_filename_component(FETCHCONTENT_BASE_DIR "${pico-sdk_FETCH_FROM_GIT_PATH}" REALPATH BASE_DIR "${CMAKE_SOURCE_DIR}")
    endif()

    RequireContent(
        pico-sdk
        GIT_REPOSITORY "https://github.com/raspberrypi/pico-sdk.git"
        GIT_TAG "master"
        GIT_SUBMODULES_RECURSE FALSE
    )

    if(NOT pico-sdk)
        message("Downloading Raspberry Pi Pico SDK")
        set(pico-sdk_PATH ${pico-sdk_SOURCE_DIR})
    endif()

    set(FETCHCONTENT_BASE_DIR ${FETCHCONTENT_BASE_DIR_SAVE})
endif()

get_filename_component(pico-sdk_PATH "${pico-sdk_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")

if(NOT EXISTS ${pico-sdk_PATH})
    message(FATAL_ERROR "Directory '${pico-sdk_PATH}' not found")
endif()

set(pico-sdk_INIT_CMAKE_FILE ${pico-sdk_PATH}/pico_sdk_init.cmake)

if(NOT EXISTS ${pico-sdk_INIT_CMAKE_FILE})
    message(FATAL_ERROR "Directory '${pico-sdk_PATH}' does not appear to contain the Raspberry Pi Pico SDK")
endif()

set(pico-sdk_PATH ${pico-sdk_PATH} CACHE PATH "Path to the Raspberry Pi Pico SDK" FORCE)

include(${pico-sdk_INIT_CMAKE_FILE})
