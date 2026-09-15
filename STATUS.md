# PennyKey status
## Current stage
Stage 2: partition creation and Windows verification complete; awaiting actual Android phone file-transfer test before Linux installation.

## Verified
- Stage 1 requirements/rules pushed to origin/main in commit 0d4c12e.
- Image SHA256 matches: thHZP.png lock screen; xd8bu.png desktop wallpaper.
- Completion script reported Windows file write/read success and removed its test file.
- After the usage-limit interruption, one read-only check confirmed this physical partition layout:

| Partition | Size bytes | Purpose | State |
| --- | ---: | --- | --- |
| 1 | 21474836480 | PennyKey shared, E: | exFAT, Windows read/write passed |
| 2 | 1073741824 | Pi boot | FAT32 PENNYPIBOOT, no drive letter |
| 3 | 1073741824 | PC EFI boot | FAT32 PENNYEFI, EFI type verified |
| 4 | 34359738368 | Pi root | Linux type allocated, not formatted |
| 5 | 70337429504 | PC root | Linux type allocated, not formatted |

Shared volume reports Healthy, filesystem size 21470642176 bytes; formatting metadata accounts for the difference from partition size. See docs/partition-result.txt.

## Executed
- USB partitioning finished; no operating system or bootloader installed.
- Unsupported optional setting recovered without restarting the wipe; see ERROR_LOG.md.
- Scripts preserved as build records. Complete-PennyKeyPartitions.ps1 is a one-time recovery script for the old two-partition state and must not be run against the completed layout.
- Initialize-PennyKey.ps1 is destructive; do not rerun on this completed USB. Its EFI step was updated to match the successful recovery method; revised full script has not been rerun end-to-end.

## Next step: user physical test
Safely eject the USB from Windows, connect it to an Android phone using the appropriate USB adapter, copy a small file from the phone to PennyKey, and open the copied file from the USB. Report which phone and whether it worked. Repeat on other intended phones when available. If Android offers to format the USB, cancel and report it; formatting would erase the prepared layout.

## Pending
Android compatibility; Pi/PC installation and physical boot tests; persistent wallpaper/lock screen; Penny applications; emulators/controllers/saves; ComfyUI; future Pi 5 and NVIDIA laptop verification.
