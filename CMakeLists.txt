cmake_minimum_required(VERSION 3.22)

include(FetchContent)

FetchContent_Declare(
    cmake-require-content
    GIT_REPOSITORY "git@github.com:weagle08/cmake-require-content.git"
    GIT_TAG "main"
)
FetchContent_MakeAvailable(cmake-require-content)

include(RequireContent)

# ########## IMPORTING PICO SDK, MUST BE BEFORE PROJECT DECLARATION #######################
include(pico-sdk-import.cmake)

# ################ END PICO SDK IMPORT ########################################################
project(hello-world-of-pi C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Initialize the SDK
pico_sdk_init()

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    message(STATUS "****ADDING DEBUG COMPILE DEFINITION****")
    add_compile_definitions(DEBUG)
endif()

add_compile_options(-Wall
    -Wno-format # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
    -Wno-unused-function # we have some for the docs that aren't called
    -Wno-maybe-uninitialized
)

include(AddExecutable)

executable(
    ${CMAKE_PROJECT_NAME}
    "src/blink.cpp"
)

target_link_libraries(
    ${CMAKE_PROJECT_NAME}
    pico_stdlib
)

pico_add_extra_outputs(${CMAKE_PROJECT_NAME})

pico_enable_stdio_usb(${CMAKE_PROJECT_NAME} 0)
pico_enable_stdio_uart(${PROJECT_NAME} 1)