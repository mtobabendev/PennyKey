# PennyKey status
## Current stage
Stage 3: preparing Pi Linux installation. Stage 2 completed: Windows verification passed and user confirmed Android files copied successfully.

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

## Completed Android checkpoint
Safely eject the USB from Windows, connect it to an Android phone using the appropriate USB adapter, copy a small file from the phone to PennyKey, and open the copied file from the USB. Report which phone and whether it worked. Repeat on other intended phones when available. If Android offers to format the USB, cancel and report it; formatting would erase the prepared layout.

## Pending
Additional-phone compatibility; Pi/PC installation and physical boot tests; persistent wallpaper/lock screen; Penny applications; emulators/controllers/saves; ComfyUI; future Pi 5 and NVIDIA laptop verification.

## 2026-09-15 installation preparation
- User confirmed Android file transfer works. Windows now sees Screenshot_20260520_221157_Nova Launcher.jpg on the shared partition (1443638 bytes). Contents not inspected.
- Ubuntu WSL2 installed; USB passthrough utility usbipd not found on PATH. Windows C: has approximately 15.57 GiB free.
- Current next step: establish Linux access to the USB, preferably through the existing Pi if available, or USB/IP with WSL. Preserve the shared partition and Android file.


## Installation handoff clarification
- Pi is reachable at user-provided address; SSH password service works, but key authorization is unresolved. No authenticated remote session established.
- User is actively configuring RetroArch/controllers on the Pi SD card. Preserve that system; no cloning or modification authorized by the USB installation scope.
- Fresh OS deployment into USB partitions is the intended method. Explain and agree the physical handoff before proceeding; do not ask user to enable already-running SSH.

## Windows-side installation route (authorized)
- User requested keeping USB on Windows and avoiding Pi command entry. Use Ubuntu WSL2 plus usbipd-win; no SSH required.
- usbipd-win 5.3.0 installed successfully. Samsung 04e8:6300 at bus 1-7 attached to Ubuntu.
- Ubuntu sees /dev/sde (128320801792 bytes) with the expected five partitions and matching PARTUUIDs. Linux reports serial 0374925110003055; Windows reports AA00000000000489. Match partition UUIDs and exact layout as well as capacity before writes.
- Downloading official 2026-06-18 Raspberry Pi OS ARM64 desktop image. Published SHA256: 123287c05f27b0eebd8f65456f6369b8f6635fa50a3d440a4f9f6223bf58c8e2.
- No OS write yet. Next: verify image hash, inspect first-boot behavior, deploy only Pi boot/root, replace filesystem references, and preserve partitions 1/3/5.

## Active OS write
The reduced Install-PiOS-WSL.sh is now writing only Pi root and boot. It removes automatic whole-disk growth, updates PARTUUID references, and configures shared storage mounting. It does not enable SSH, install keys, or customize the desktop. Fresh desktop account setup remains for first boot. Completion checks are still running; do not re-run the destructive script.
