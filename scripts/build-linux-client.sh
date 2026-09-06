#!/bin/sh
# Builds mcpelauncher-client for Linux (client only; the UI comes from upstream's AppImage/Flatpak/deb).
# Debian/Ubuntu deps: clang cmake make git libssl-dev libpng-dev libzip-dev libx11-dev libxi-dev
#   libudev-dev libevdev-dev libegl1-mesa-dev libgles2-mesa-dev libasound2-dev libpulse-dev pkg-config
set -eu
SRC=$(cd "$(dirname "$0")/.." && pwd)
BUILD=${BUILD_DIR:-$SRC/build-linux}
CC=${CC:-clang} CXX=${CXX:-clang++} cmake -S "$SRC" -B "$BUILD" -Wno-dev \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DBUILD_UI=OFF -DBUILD_WEBVIEW=OFF -DENABLE_QT_ERROR_UI=OFF \
  -DMSA_DAEMON_PATH=. -DXAL_WEBVIEW_QT_PATH=. -DENABLE_DEV_PATHS=OFF \
  -DJNI_USE_JNIVM=ON -DBUILD_FAKE_JNI_TESTS=OFF -DBUILD_FAKE_JNI_EXAMPLES=OFF \
  -DUSE_OWN_CURL=ON \
  -DCMAKE_CXX_FLAGS="-DNDEBUG"
cmake --build "$BUILD" --target mcpelauncher-client -j"$(nproc)"
echo "built $BUILD/mcpelauncher-client/mcpelauncher-client"
