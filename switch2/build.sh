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

# Stop if the NRO is not marked as a Switch 2 program (old SDK or libnx).
python3 "$ROOT/switch2/check_nro.py" "$BUILD/mm/2ship.nro"

if [ ! -f "$ROOT/2ship.o2r" ]; then
    echo "2ship.o2r is missing. Make it with the host build first (see switch2/README.md)." >&2
    exit 1
fi

rm -rf "$DIST"
mkdir -p "$DIST/switch/2s2h"
cp "$BUILD/mm/2ship.nro" "$DIST/switch/2s2h/2ship.nro"
cp "$ROOT/2ship.o2r" "$DIST/switch/2s2h/2ship.o2r"
cp "$ROOT/switch2/PLAYER-README.txt" "$DIST/readme.txt"
cp "$ROOT/switch2/GAME-DATA.md" "$DIST/GAME-DATA.md"
cp "$ROOT/switch2/CHANGELOG.md" "$DIST/CHANGELOG.md"

(cd "$DIST" && rm -f ../2s2h-switch2.zip && zip -qr ../2s2h-switch2.zip switch readme.txt GAME-DATA.md CHANGELOG.md)

if unzip -l "$BUILD/2s2h-switch2.zip" | grep -q "mm.o2r"; then
    echo "mm.o2r is in the zip. Do not share it." >&2
    exit 1
fi

# Keep the ELF of this NRO next to the zip (not in it). Crash reports
# (logs/crash-*.txt) give code offsets that only this ELF can resolve:
#   aarch64-none-elf-addr2line -Cfipe 2ship-<commit>.elf 0x<offset> ...
COMMIT=$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)
for elf in "$BUILD/mm/2ship.elf" "$BUILD/mm/2ship"; do
    if [ -f "$elf" ]; then
        cp "$elf" "$BUILD/2ship-$COMMIT.elf"
        echo "ELF for crash reports: $BUILD/2ship-$COMMIT.elf"
        break
    fi
done

echo "Done: $BUILD/2s2h-switch2.zip"
