# 2 Ship 2 Harkinian for Switch 2 (ounce) - test build

This is an unofficial test build of 2 Ship 2 Harkinian for the Nintendo
Switch 2. It runs as homebrew from the homebrew menu (hbloader).

## Install

1. Copy the `switch` folder from this zip to the root of your SD card. You get:

   ```
   sdmc:/switch/2s2h/2ship.nro
   sdmc:/switch/2s2h/2ship.o2r
   ```

2. Make `mm.o2r` from your own Majora's Mask ROM (see `GAME-DATA.md`), and
   copy it to `sdmc:/switch/2s2h/`.

3. Start 2 Ship 2 Harkinian from the homebrew menu.

This zip does not have `mm.o2r`. It is made from the ROM, so it has game
data that cannot be shared. Make it yourself from a ROM you dumped.

## Playing

- Press `-` to open the menu.
- Default buttons: B is A, Y is B, A is C-down, X is C-left, R is C-right,
  ZL is Z, ZR is R. The right stick is also the C buttons. If you played an
  earlier build, your saved controls stay: reset them in the input editor to
  get these.
- Only the US ROMs are supported, so the game is in English only.
- Quit: use "the power button at the top of the menu" in the menu to go back to the homebrew menu.
  Closing the game from the HOME menu also works.
- 120 FPS: on the Switch 2 screen, set the FPS slider in the graphics
  settings above 60. With vsync on, the game is held to the display's refresh
  rate (120 Hz handheld, 60 Hz on most TVs).
- Bug reports: the log is in `/switch/2s2h/logs/`. Send it with the report.
  Some crashes also leave a `crash-<date>.txt` file there. CPU faults do not:
  the console does not pass them to homebrew.
- Debugging: with a `debug-host.txt` (a computer's IP) next to the NRO, the game
  streams its state over UDP to `switch2/debug_listener.py`. Without that file
  the stream and audio diagnostics are off.

## Make mm.o2r

`GAME-DATA.md` (next to this file) explains it step by step. In short: the
console cannot make `mm.o2r`. Make it on a computer with the PC build of the
same version as this Switch 2 build, from
<https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases> (Windows,
macOS and Linux). This build is 5.1.0, from the development line: an `mm.o2r`
from the public PC release 5.0.1 has different game data and can crash.

Supported ROMs (SHA-1):

- NTSC-U 1.0: `d6133ace5afaa0882cf214cf88daba39e266c078`
- NTSC-U GameCube: `9743aa026e9269b339eb0e3044cd5830a440c1fd`

## Build from source

You need devkitPro with `switch-dev` and `switch-portlibs`, and the ounce
devkit 20261114 or newer unpacked into `$DEVKITPRO` (it adds `libounce` and
`portlibs/switch2`). Older SDKs are refused: their NROs are not marked as
Switch 2 programs, and the console warns about them.

1. Make `2ship.o2r` and `mm.o2r` with a host (computer) build. Put the ROM at
   `OTRExporter/baserom.z64` (big-endian `.z64` format), then from the repo
   root:

   ```sh
   cmake -H. -Bbuild-cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
   cmake --build build-cmake --target ExtractAssets
   ```

   With Apple Clang 21 or later, add `-DCMAKE_CXX_FLAGS="-DFMT_CONSTEVAL= "`
   to the first command.

2. Build the NRO and the test zip:

   ```sh
   sh switch2/build.sh
   ```

   This writes `build-switch2/2s2h-switch2.zip`. The script stops if
   `mm.o2r` gets into the zip.

## Changes for Switch 2

- `switch2/cmake/Switch2.cmake`: the CMake toolchain. It loads the devkit's
  own `$DEVKITPRO/libounce/cmake/Switch2.cmake` (libounce, the Switch 2
  portlibs with EGL and GL on OunceVK through Zink first, `-D__SWITCH2__` and
  the Switch 2 CPU flags). `CMAKE_SYSTEM_NAME` stays `NintendoSwitch`, so the
  Switch code is used.
- `switch2/check_nro.py`: `build.sh` runs it on `2ship.nro` to check that
  libounce marked it as a Switch 2 program (the `OUN0` record).
- `mm/CMakeLists.txt`: on Switch 2 the homebrew menu title is
  "HarbourMasters - 2Ship", next to "HarbourMasters - Shipwright".
- libultraship (`2ship-ounce` branch): the Switch 1 CPU clock control is off,
  and the display size is 1920x1080 in handheld and docked mode. OpenGL is a
  4.1 core context with the core-profile shaders (as on macOS): Switch 2's
  OpenGL is Zink on Vulkan, and the Switch 1 path (GLSL 1.10/1.30, no vertex
  array object) drew nothing there. The log has the OpenGL version and
  renderer.
- The "Switch performance mode" menu is hidden on Switch 2.
