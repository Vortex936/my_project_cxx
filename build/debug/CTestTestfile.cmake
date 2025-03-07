# CMake generated Testfile for 
# Source directory: /home/sigurd/Code/c++/programmering2/my_project
# Build directory: /home/sigurd/Code/c++/programmering2/my_project/build/debug
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test([=[it_works]=] "/home/sigurd/Code/c++/programmering2/my_project/build/debug/bin/tests" "it_works")
set_tests_properties([=[it_works]=] PROPERTIES  _BACKTRACE_TRIPLES "/home/sigurd/Code/c++/programmering2/my_project/CMakeLists.txt;415;add_test;/home/sigurd/Code/c++/programmering2/my_project/CMakeLists.txt;0;")
subdirs("_deps/std-build")
