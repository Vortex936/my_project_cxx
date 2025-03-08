# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-src")
  file(MAKE_DIRECTORY "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-src")
endif()
file(MAKE_DIRECTORY
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-build"
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix"
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/tmp"
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/src/std_module-populate-stamp"
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/src"
  "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/src/std_module-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/src/std_module-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/sigurd/Code/c++/programmering2/my_project_cxx/build/debug/_deps/std_module-subbuild/std_module-populate-prefix/src/std_module-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
