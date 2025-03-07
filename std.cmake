if (NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  message(FATAL_ERROR "std module requires Clang")
endif()

if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "18.1.0")
  message(FATAL_ERROR "std module requires Clang 18.1.0 or later")
endif()

include(FetchContent)
FetchContent_Declare(
  std_module
  URL "file://${STD_LIB_PATH}"
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SYSTEM
)

if (NOT std_module_POPULATED)
  FetchContent_Populate(std_module)
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
    -Wl,-rpath=${CLANG_DIR}/../lib/${CLANG_TARGET}
)

target_link_libraries(std
  INTERFACE
    c++
)

link_libraries(std)