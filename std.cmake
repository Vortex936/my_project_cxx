# I got this from https://github.com/llvm/llvm-project/issues/80231#issuecomment-1922037108

if (NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  message(FATAL_ERROR "std module requires Clang")
endif()

if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "18.1.0")
  message(FATAL_ERROR "std module requires Clang 18.1.0 or later")
endif()

#execute_process(COMMAND bash "-c" "${CMAKE_CXX_COMPILER} -v 2>&1 > /dev/null | grep 'InstalledDir' | awk '{print $2}' | tr -d '\n'" OUTPUT_VARIABLE CLANG_DIR)
#execute_process(COMMAND bash "-c" "${CMAKE_CXX_COMPILER} -v 2>&1 > /dev/null | grep 'Target: ' | awk '{print $2}' | tr -d '\n'" OUTPUT_VARIABLE CLANG_TARGET)

include(FetchContent)
FetchContent_Declare(
  std_module
  URL "file://${STD_LIB_PATH}"
  #URL "file://${CLANG_DIR}/../share/libc++/v1"
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SYSTEM
)

if (NOT std_module_POPULATED)
  FetchContent_MakeAvailable(std_module)
endif()

add_library(std)
target_sources(std
  PUBLIC FILE_SET cxx_modules TYPE CXX_MODULES FILES
    ${std_module_SOURCE_DIR}/std.cppm
    ${std_module_SOURCE_DIR}/std.compat.cppm
)

target_compile_options(std
  PUBLIC
    -stdlib=libc++
    -Wno-reserved-module-identifier
    -Wno-reserved-user-defined-literal
)
target_compile_features(std
  PRIVATE
    cxx_std_23
)

target_link_options(std
  PUBLIC
    -stdlib=libc++
    -Wl,-rpath,"${STD_LIB_PATH}"
)

target_link_libraries(std
  INTERFACE
    c++
)

link_libraries(std)