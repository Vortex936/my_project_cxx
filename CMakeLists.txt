# CMakeLists.txt

# Require CMake version
cmake_minimum_required(VERSION 3.26 FATAL_ERROR)

# Define project
# Change VERSION and DESCRIPTION to whatever you want
# `MY_PROJECT` is a variable name, and must not be changed
project(MY_PROJECT
  VERSION 1.0.0
  DESCRIPTION "My project"
  LANGUAGES CXX
)

# Enable libc++ standard library
set(ENV{CLANG_DEFAULT_CXX_STDLIB} libc++)
# Enable LLVM compiler runtime
set(ENV{CLANG_DEFAULT_RTLIB} compiler-rt)

# OS-specific settings
# If using clang, you need at least version 18 for proper module support.
# On Linux, libc++ with module support is needed.
# On MacOS, libc++ with module support is included when installing clang.
# On Archlinux, this is a separate package, and clang uses stdlibc++ instead by default, which does not support modules.
# The stock version on MacOS is version 16
# The stable version (package clang) on ArchLinux is version 17
if(CMAKE_SYSTEM_NAME STREQUAL "Linux") # Linux
  message("OS: Linux")

  # On Archlinux, requires the following packages:
  # - cmake
  # - llvm-minimal-git
  # - libc++abi
  #     - AUR package is outdated, needs manual upgrade to version 1.19.7 or higher.
  #     - Set `pkgver` in PKGBUILD to 1.19.7 (or higher) then do `makepkg -si`
  # Needs equivalent packages on other Linux distributions

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "/usr/bin/clang")
  set(CMAKE_CXX_COMPILER "/usr/bin/clang++")

  # Path to libc++ source files
  # Change this to where it is located on your system
  set(STD_LIB_PATH "/usr/share/libc++/v1")

  # Path to libc++ header files
  # Change this to where it is located on your system
  set(STD_INCLUDE_PATH "/usr/include/c++/v1")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin") # MacOS
  message("OS: MacOS")

  # On macOS, requires the following MacPorts packages:
  # - cmake
  # - clang-19
  # - procs
  # If you are using a different version of clang, the paths need to be changed

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "/opt/local/libexec/llvm-19/bin/clang")
  set(CMAKE_CXX_COMPILER "/opt/local/libexec/llvm-19/bin/clang++")

  # Path to libc++ source files
  # Change this to where it is located on your system
  set(STD_LIB_PATH "/opt/local/libexec/llvm-19/local/libexec/libc++/v1")

  # Path to libc++ header files
  # Change this to where it is located on your system
  set(STD_INCLUDE_PATH "/opt/local/libexec/llvm-19/local/include/c++/v1")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows") # Windows
  message("OS: Windows")

  # Not sure how to do this on Windows
  # It might be better to use the MSVC standard library (STL) instead of libc++
  # MSVC and STL can be installed with the Microsoft VisualStudio installer.
  # Clang can also be used instead of MSVC.
  # libc++, however i'm not sure is available on Windows at all.

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "C:/path/to/clang.exe")
  set(CMAKE_CXX_COMPILER "C:/path/to/clang++.exe")

  # Path to libc++ source files
  # Change this to where it is located on your system
  set(STD_LIB_PATH "C:/path/to/libc++/library/folder")

  # Path to libc++ header files
  # Change this to where it is located on your system
  set(STD_INCLUDE_PATH "C:/path/to/libc++/headers/folder")
endif()

# Require C++23 standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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

# Enable libc++ for xcode
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY libc++)

# Set maximum error count
# Change this to whatever you want
set(MAX_ERRORS 32)

# Enable extra warnings and errors
add_compile_options(-fdiagnostics-color=always)
add_compile_options(
    -Wall
    -Wextra
    -pedantic
    -Wpedantic
    -Wsign-conversion
    -Wconversion
    -Werror=switch
    -Wdouble-promotion
    -Wnull-dereference
    -Winfinite-recursion
    -Wmisleading-indentation
    -Werror=return-local-addr
    -Wno-c++23-extensions
    -Werror=shadow
    -Wpointer-arith
    -Wcast-qual
    -Wstrict-prototypes
    -Wmissing-prototypes
    -Wformat=2
    -Wundef
    -Wuninitialized
    -Winit-self
    #-Wfloat-equal
    -Wwrite-strings
    -Wmissing-field-initializers
    -Wredundant-decls
    -Waggregate-return
    -Wstrict-aliasing=2
    -Warray-bounds
    -Wcast-align
    -Wswitch-default
    -Wswitch-enum
    -Wstack-protector
    -Wold-style-definition
    -Wbad-function-cast
    -Wc++-compat
    -Wdeclaration-after-statement
    -Wmissing-declarations
    -Wmissing-include-dirs
    -Wnested-externs
    -Wpacked
    -Wpadded
    -Wredundant-decls
    -Wsign-compare
    -Wstrict-overflow=5
    -Wvla
    -Wdisabled-optimization
    -Winline
    -Winvalid-pch
    -Wmissing-format-attribute
    -Woverlength-strings
    -Wpragmas
    -Wunused-but-set-parameter
    -Wunused-but-set-variable
    -Wunused-const-variable
    -Wunused-function
    -Wunused-label
    -Wunused-local-typedef
    -Wunused-macros
    -Wunused-parameter
    -Wunused-value
    -Wunused-variable
    -Wvariadic-macros
    -Wno-braced-scalar-init
)

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

# Compiler specific warnings
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-fmax-errors=${MAX_ERRORS})
  add_compile_options(-Wformat-overflow=2)
  include(gcc_modules.cmake)
else()
  add_compile_options(-Wstrict-overflow)
endif()

# Include standard library headers
# Change this path to wherever the standard library is on your system
add_compile_options(-cxx-isystem${STD_INCLUDE_PATH})

# Include from environment
# Try disabling this if you have linker problems(?)
if(NOT "$ENV{CPLUS_INCLUDE_PATH}" STREQUAL "")
    string(REPLACE ":" ";" CPLUS_INCLUDE_PATH_LIST "$ENV{CPLUS_INCLUDE_PATH}")
    include_directories(${CPLUS_INCLUDE_PATH_LIST})
endif()

# Use libc++ and lld
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -isystem${STD_INCLUDE_PATH}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi -fuse-ld=lld")

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
  #add_dependencies(${target} std-populate)
  #target_link_libraries(${target} std)
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
  list(LENGTH HEADER_DIRS LENGTH_DIRS)
  if(LENGTH_DIRS GREATER 0)
    directories_of(HEADER_DIRS ${MODULES} ${HEADERS})
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

# This is the target we link everything to
set(LIB_TARGET MY_PROJECT)

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
