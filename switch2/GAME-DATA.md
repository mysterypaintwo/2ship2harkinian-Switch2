# Make the game data for 2 Ship 2 Harkinian (Switch 2)

The Switch 2 build needs `mm.o2r`, made from your own Majora's Mask ROM. This
file holds the game's data, so it is not in the download: you make it once, on
a computer, with the PC version of 2 Ship 2 Harkinian.

**Use the PC version from the same release as this Switch 2 build.** The
Switch 2 build is version 5.1.0, from 2 Ship 2 Harkinian's development line.
Its game data differs from the one the public PC release (5.0.1) makes, so an
`mm.o2r` from 5.0.1 can show wrong graphics or crash. The release page that has
this Switch 2 build also has PC builds of the same version for Windows, macOS
and Linux:
<https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases>

## What you need

- A computer with Windows, macOS or Linux.
- A Majora's Mask ROM that you dumped yourself, in one of these versions:

  | ROM | SHA-1 |
  |---|---|
  | US (N64) | `d6133ace5afaa0882cf214cf88daba39e266c078` |
  | US (GameCube) | `9743aa026e9269b339eb0e3044cd5830a440c1fd` |

  The `.z64`, `.n64` and `.v64` byte orders all work. To check a ROM, compare
  its SHA-1 with the table (for example `certutil -hashfile rom.z64 SHA1` on
  Windows, `shasum rom.z64` on macOS and Linux). A `.n64` or `.v64` file has
  another SHA-1 until the PC version converts it.

## Steps

1. From the release page above, download the PC build for your computer:
   `2ship-windows.zip`, `2ship-mac.zip` or `2ship-linux.zip`.
2. Unzip it and start 2 Ship 2 Harkinian.
3. When it asks for a ROM, choose your ROM file. It makes the game data. This
   takes a few minutes. Then the game starts: you can close it.
4. Find `mm.o2r`:
   - Windows: in the folder of the program.
   - macOS: in `~/Library/Application Support/2ship/` (in Finder: Go > Go to
     Folder).
   - Linux: in the folder of the program, or in `~/.local/share/2ship/`.

   If it is not there, search your computer for `mm.o2r`.
5. Copy `mm.o2r` to `/switch/2s2h/` on the Switch 2's SD card, next to
   `2ship.nro` and `2ship.o2r`.

## If it does not start

- "Outdated ROM Archive": the file was made by another major version. Make it
  again with the PC build from this release.
- Nothing happens or the game closes: send `/switch/2s2h/logs/` from the SD
  card with your report. After a crash, the folder also has a
  `crash-<date>.txt` file.
