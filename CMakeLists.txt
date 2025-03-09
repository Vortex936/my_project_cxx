# CMakeLists.txt

# Require CMake version
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

# Set this to OFF to disable `libc++`.
set(USE_LIBCXX ON)

include(os.cmake)

# Define project
# Change VERSION and DESCRIPTION to whatever you want
# `MY_PROJECT` is a variable name, and must not be changed
project(MY_PROJECT
  VERSION 1.0.0
  DESCRIPTION "My project"
  LANGUAGES CXX
)
# This is the target we link everything to
set(LIB_TARGET MY_PROJECT)

include(os.cmake)

if(USE_LIBCXX)
  # Enable libc++ standard library
  set(ENV{CLANG_DEFAULT_CXX_STDLIB} libc++)
endif()
# Enable LLVM compiler runtime
set(ENV{CLANG_DEFAULT_RTLIB} compiler-rt)

if(USE_LIBCXX)
  include(std_libcxx.cmake)
endif()

# Require C++23 standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Enable module support for different versions of CMake
if(CMAKE_VERSION VERSION_LESS "3.28.0")
  if(CMAKE_VERSION VERSION_LESS "3.27.0")
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "2182bf5c-ef0d-489a-91da-49dbc3090d2a")
  else()
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "aa1f7df0-828a-4fcd-9afc-2dc80491aca7")
  endif()
  set(CMAKE_EXPERIMENTAL_CXX_MODULE_DYNDEP 1)
else()
  cmake_policy(VERSION 3.28)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable scanning for modules
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

# Define module build directory
set(PREBUILT_MODULE_PATH ${CMAKE_BINARY_DIR}/modules)

# Define binary output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Export compile commands
# This is needed for clangd or microsoft C/C++ intellisense to work.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(USE_LIBCXX)
  # Enable libc++ for xcode
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY libc++)
endif()

include(warnings.cmake)

# Feature flags for modules
add_compile_options(-fbuiltin-module-map)
add_compile_options(-fimplicit-module-maps)
add_compile_options(-fprebuilt-module-path=${PREBUILT_MODULE_PATH})
add_compile_options(-fmodules)
#add_compile_options(-fimplicit-modules)
#add_compile_options(-fretain-comments-from-system-headers)

# This crashes the compiler with clang 20
# Don't do this, unless you have to to make it work
# Might be version specific
#add_compile_options(-Xclang)
#add_compile_options(-emit-module-interface)

# Include standard library headers
add_compile_options(-cxx-isystem${STD_INCLUDE_PATH})

# Include from environment
# Try disabling this if you have linker problems(?)
if(NOT "$ENV{CPLUS_INCLUDE_PATH}" STREQUAL "")
    string(REPLACE ":" ";" CPLUS_INCLUDE_PATH_LIST "$ENV{CPLUS_INCLUDE_PATH}")
    include_directories(${CPLUS_INCLUDE_PATH_LIST})
endif()

if(USE_LIBCXX)
  # Use libc++
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -isystem${STD_INCLUDE_PATH}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++")
endif()

# Use lld
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lc++abi -fuse-ld=lld")

# Set project source directory
set(PROJECT_SOURCE_DIR src)

# Find module files in ./src
file(GLOB_RECURSE MODULES
  CONFIGURE_DEPENDS
    ${PROJECT_SOURCE_DIR}/*.cppm
    ${PROJECT_SOURCE_DIR}/*.ixx
)
# Find header files in ./src
file(GLOB_RECURSE HEADERS
  CONFIGURE_DEPENDS
    ${PROJECT_SOURCE_DIR}/*.h
    ${PROJECT_SOURCE_DIR}/*.hpp
    ${PROJECT_SOURCE_DIR}/*.tpp
)
# Find source files in ./src
file(GLOB_RECURSE SOURCES
  CONFIGURE_DEPENDS
    ${PROJECT_SOURCE_DIR}/*.c
    ${PROJECT_SOURCE_DIR}/*.cpp
)

# This macro finds directories of a list of files
macro(directories_of return_list new_list)
    set(dir_list "")
    foreach(file_path ${new_list})
        get_filename_component(dir_path ${file_path} PATH)
        set(dir_list ${dir_list} ${dir_path})
    endforeach()
    list(REMOVE_DUPLICATES dir_list)
    set(${return_list} ${dir_list})
endmacro()

# This macro links the standard library to a target
macro(link_std target)
  add_dependencies(${target} std)
  target_link_libraries(${target} std)
  target_compile_features(${target} PRIVATE cxx_std_23)
endmacro()

# This macro links the module files (.cppm, .ixx) in ./src to a target
macro(link_modules target)
  target_sources(
    ${target}
    PUBLIC
    FILE_SET CXX_MODULES FILES
      ${MODULES}
  )
endmacro()

# This macro includes the directories of the header files (.hpp) in ./src to a target
macro(include_header_dirs target)
  set(MODULES_AND_HEADERS)
  list(APPEND MODULES_AND_HEADERS ${MODULES} ${HEADERS})
  directories_of(HEADER_DIRS MODULES_AND_HEADERS)
  list(LENGTH HEADER_DIRS LENGTH_DIRS)
  if(LENGTH_DIRS GREATER 0)
    target_include_directories(
      ${target}
      BEFORE PUBLIC
        ${HEADER_DIRS}
    )
  endif()
endmacro()

# This macro links the source files (.cpp) in ./src to a target
macro(link_sources target)
  target_sources(
    ${target}
    PRIVATE
      ${SOURCES}
  )
endmacro()

# This macro links and includes everything to a target
macro(link_and_include target)

  link_std(${target})
  include_header_dirs(${target})
  link_modules(${target})
  link_sources(${target})

  target_precompile_headers(
    ${target}
    PUBLIC
      ${HEADERS}
  )
endmacro()

# This macro adds an executable to a target with a chosen entry-point
macro(add_exe target entry_point)
  add_executable(${target} ${entry_point})
  link_and_include(${target})
endmacro()

# Link everything to our target, unless there is nothing to link
list(LENGTH SOURCES LENGTH_SOURCES)
list(LENGTH MODULES LENGTH_MODULES)
set(LENGTH ${LENGTH_SOURCES} + ${LENGTH_MODULES})
if(LENGTH GREATER 0)
  add_library(${LIB_TARGET} SHARED)
  link_and_include(${LIB_TARGET})
endif()

# Add executable with entry point in main.cpp
add_exe(main main.cpp)

# ------------------------------------------------------------- CTest -----------------------------------------------------------------

# Enable testing
enable_testing()

# Set this to OFF to disable CTest
# Set this to ON to enable CTest
set(BUILD_TESTING ON)

# Makes sure you are in the correct project before building CTest
# This is important
if(${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
  # Include CTest library
  include(CTest)

  set(TESTS_BASE_DIR "tests")

  if(${BUILD_TESTING})
    # Find test entry-points
    file(GLOB_RECURSE TESTS
      CONFIGURE_DEPENDS
        "${TESTS_BASE_DIR}/*.cpp"
    )

    cmake_path(ABSOLUTE_PATH TESTS_BASE_DIR)

    # Retrieve names of tests
    set(TEST_NAMES)
    foreach(TEST ${TESTS})
      file(RELATIVE_PATH TEST_NAME ${TESTS_BASE_DIR} ${TEST})
      cmake_path(REMOVE_EXTENSION TEST_NAME)
      string(REGEX REPLACE "/" ":" TEST_NAME "${TEST_NAME}")
      set(TEST_NAMES ${TEST_NAMES} "${TEST_NAME}")
    endforeach()

    # Add tests to omit here
    # Write the name of the test without file extension
    set(OMIT
      #"it_works"
      #":oblig1"
      #":oblig2"
      #":ov_oppg"
    )

    # Print tests that are omitted, then remove them from list
    foreach(OMIT_FILTER ${OMIT})
      list(FILTER TEST_NAMES EXCLUDE REGEX "${OMIT_FILTER}")
    endforeach()

    # Create test sourcelist for CTest
    list(LENGTH TEST_NAMES LENGTH)
    if(LENGTH GREATER 0)
      create_test_sourcelist(test_main "tests.cpp" ${TEST_NAMES})

      # Add each test to CTest
      foreach(TEST_NAME ${TEST_NAMES})
        message(${TEST_NAME})
        add_test(NAME ${TEST_NAME} WORKING_DIRECTORY ${RUNTIME_OUTPUT_DIRECTORY} COMMAND tests ${TEST_NAME})
      endforeach()

      # Add executable for running CTest
      add_exe(tests ${test_main})

      # Link test entry-points to sources
      target_sources(
        tests
        PRIVATE
          ${TESTS}
      )

      # Needed for CTest to compile
      # Crashes clangd if used on whole project
      #target_compile_options(tests PRIVATE -fimplicit-modules)
      target_compile_options(tests PRIVATE -fmodules)

      # Prevents warning on entry-point
      target_compile_options(tests PRIVATE -Wno-missing-prototypes)

      # This is not needed with clang 20
      # May be needed for older versions of clang
      #target_link_libraries(tests, CTest::main)
    endif()
  endif()
endif()
