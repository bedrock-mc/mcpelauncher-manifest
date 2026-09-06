# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext")
  file(MAKE_DIRECTORY "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext")
endif()
file(MAKE_DIRECTORY
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext-build"
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/ext/curl"
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/tmp"
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext-stamp"
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src"
  "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/Users/hashim/Coding/other/mcpelauncher-manifest/build-macos/curl_ext-prefix/src/curl_ext-stamp${cfgdir}") # cfgdir has leading slash
endif()
