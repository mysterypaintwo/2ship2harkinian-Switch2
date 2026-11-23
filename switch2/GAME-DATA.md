# Make the game data (mm.o2r)

The game data is not included. You make `mm.o2r` once from your own ROM, using
the PC tool below. Other PC versions can make data that does not work.

## You need

- A Windows, macOS or Linux computer.
- Your own US Majora's Mask ROM (`.z64`, `.n64` or `.v64`), N64 or GameCube.

## Steps

1. Download the PC build for your computer from the
   [PC tools release](https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases/tag/v1.0-pre):
   - [Windows](https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases/download/v1.0-pre/2ship-windows.zip)
   - [macOS](https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases/download/v1.0-pre/2ship-mac.zip)
   - [Linux](https://github.com/mysterypaintwo/2ship2harkinian-Switch2/releases/download/v1.0-pre/2ship-linux.zip)
2. Unzip it and start 2 Ship 2 Harkinian.
   - macOS may block it. Try to open it once, then click **Open Anyway** in
     System Settings > Privacy & Security.
3. Choose your ROM when asked. When the game starts, close it.
4. Find `mm.o2r`:
   - Windows: the program's folder.
   - macOS: `~/Library/Application Support/2ship/`
   - Linux: the program's folder or `~/.local/share/2ship/`
5. Copy `mm.o2r` to `/switch/2s2h/` on your SD card.

If the game says "Outdated ROM Archive", make `mm.o2r` again with the PC build
linked above.
