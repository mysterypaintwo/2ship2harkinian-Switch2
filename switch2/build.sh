#!/bin/sh
# Builds 2ship.nro for Switch 2 (ounce) and packs a test zip.
# Run from the repo root: sh switch2/build.sh
#
# The zip has only files that are safe to share: the NRO, 2ship.o2r (the
# port's own assets) and the readme. mm.o2r is made from the ROM, so it is
# never put in the zip. Each tester makes their own.
set -e

: "${DEVKITPRO:=/opt/devkitpro}"
export DEVKITPRO

ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD="$ROOT/build-switch2"
DIST="$BUILD/dist"

if [ ! -f "$BUILD/CMakeCache.txt" ]; then
    cmake -S "$ROOT" -B "$BUILD" -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$ROOT/switch2/cmake/Switch2.cmake" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
fi
cmake --build "$BUILD" --target 2ship_nro

if [ ! -f "$ROOT/2ship.o2r" ]; then
    echo "2ship.o2r is missing. Make it with the host build first (see switch2/README.md)." >&2
    exit 1
fi

rm -rf "$DIST"
mkdir -p "$DIST/switch/2s2h"
cp "$BUILD/mm/2ship.nro" "$DIST/switch/2s2h/2ship.nro"
cp "$ROOT/2ship.o2r" "$DIST/switch/2s2h/2ship.o2r"
cp "$ROOT/switch2/README.md" "$DIST/readme.txt"

(cd "$DIST" && rm -f ../2s2h-switch2.zip && zip -qr ../2s2h-switch2.zip switch readme.txt)

if unzip -l "$BUILD/2s2h-switch2.zip" | grep -q "mm.o2r"; then
    echo "mm.o2r is in the zip. Do not share it." >&2
    exit 1
fi

echo "Done: $BUILD/2s2h-switch2.zip"
