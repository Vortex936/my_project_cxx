
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
  # Needs equivalent packages on other Linux distributions

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "/usr/bin/clang")
  set(CMAKE_CXX_COMPILER "/usr/bin/clang++")

  # Path to Ninja
  # Change this to where it is located on your system
  set(CMAKE_MAKE_PROGRAM "/usr/bin/ninja")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin") # MacOS
  message("OS: MacOS")

  # On macOS, requires the following MacPorts packages:
  # - cmake
  # - procs
  # - ninja
  # - clang-19
  # If you are using a different version of clang, the paths need to be changed

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "/opt/local/libexec/llvm-19/bin/clang")
  set(CMAKE_CXX_COMPILER "/opt/local/libexec/llvm-19/bin/clang++")

  # Path to Ninja
  # Change this to where it is located on your system
  set(CMAKE_MAKE_PROGRAM "/opt/local/bin/ninja")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows") # Windows
  message("OS: Windows")

  # libc++ is not available on Windows
  # You can use GCC's stdlibc++ or Microsoft's STL.
  # Not sure how to do this on Windows
  # If you have installed clang through the Microsoft Developer Tools installer, the compiler paths should be correct.
  # Contributions on the git repo are greatly appreciated

  # Set compiler
  # Change this to where it is located on your system
  set(CMAKE_C_COMPILER "C:/msys64/clang64.exe")
  set(CMAKE_CXX_COMPILER "C:/msys64/clang64.exe")

  # Path to stdlibc++ or STL source files
  # Change this to where it is located on your system
  set(STD_LIB_PATH "C:/path/to/libc++/library/folder")

  # Path to stdlibc++ or STL header files
  # Change this to where it is located on your system
  set(STD_INCLUDE_PATH "C:/path/to/libc++/headers/folder")

  # Path to Ninja
  # Change this to where it is located on your system
  set(CMAKE_MAKE_PROGRAM "C:/path/to/ninja.exe")

  set(USE_LIBCXX OFF)
endif()