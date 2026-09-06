#!/bin/sh
# Builds mcpelauncher-client for the local machine and installs it into an existing
# "Minecraft Bedrock Launcher.app" (the UI, webview and frameworks stay as shipped).
# Needs Xcode CLT, cmake, and brew openssl@3 libpng libzip.
set -eu
SRC=$(cd "$(dirname "$0")/.." && pwd)
BUILD=${BUILD_DIR:-$SRC/build-macos}
APP=${MCPELAUNCHER_APP:-"/Applications/Minecraft Bedrock Launcher.app"}
cmake -S "$SRC" -B "$BUILD" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DCMAKE_OSX_ARCHITECTURES="$(uname -m)" \
  -DBUILD_UI=OFF -DBUILD_WEBVIEW=OFF -DENABLE_QT_ERROR_UI=OFF \
  -DMSA_DAEMON_PATH=. -DXAL_WEBVIEW_QT_PATH=. -DENABLE_DEV_PATHS=OFF \
  -DJNI_USE_JNIVM=ON -DBUILD_FAKE_JNI_TESTS=OFF -DBUILD_FAKE_JNI_EXAMPLES=OFF \
  -DUSE_OWN_CURL=ON -DOPENSSL_ROOT_DIR="$(brew --prefix openssl@3)" \
  -DCMAKE_CXX_FLAGS="-DNDEBUG -Wl,-rpath,@loader_path/../Frameworks"
cmake --build "$BUILD" --target mcpelauncher-client -j"$(sysctl -n hw.ncpu)"

BIN="$BUILD/mcpelauncher-client/mcpelauncher-client"
# Link against the libcrypto shipped in the app bundle, not the build machine's Homebrew copy,
# so the binary runs on machines without Homebrew.
for lib in $(otool -L "$BIN" | awk '/libcrypto.*dylib/ {print $1}' | grep -v '^@'); do
  install_name_tool -change "$lib" @rpath/libcrypto.dylib "$BIN"
done
codesign --force --sign - "$BIN"
if [ "${1:-}" = "--install" ]; then
  case "$(uname -m)" in arm64) NAME=mcpelauncher-client-arm64-v8a ;; *) NAME=mcpelauncher-client ;; esac
  DEST="$APP/Contents/MacOS/$NAME"
  [ -f "$DEST.orig" ] || cp -p "$DEST" "$DEST.orig"
  cp "$BIN" "$DEST"
  codesign --force --sign - "$DEST"
  echo "installed $DEST (original kept as $DEST.orig)"
fi
