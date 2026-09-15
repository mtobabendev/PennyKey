# PennyKey status
## Current stage
Stage 3: fresh Pi OS installed and offline verification passed. Physical Pi boot and first-login setup pending. Do not rerun partitioning or installation scripts.

## Completed and verified
- Stage 1: requirements, rules and image assignments saved and pushed.
- Stage 2: five-partition layout created; Windows read/write verified; user confirmed successful Android transfer.
- Stage 3 installation: official 2026-06-18 Raspberry Pi OS ARM64 desktop image checksum verified; fresh filesystem written only to Pi root and boot partitions through Ubuntu WSL USB passthrough.
- Pi root filesystem checked and expanded to its assigned 32 GiB. Pi boot files compared against the source image, except intentionally updated cmdline.txt.
- Boot/root PARTUUID references updated; automatic first-boot partition growth disabled to preserve PC space. Shared exFAT configured at /media/PennyKey for UID/GID 1000.
- Partition table compared unchanged before/after; shared files verified against pre-install SHA256. Android-copied file preserved.
- USB detached from WSL after flushing/unmounting. Temporary keep-alive helper stopped.
- See docs/pi-os-source.md and docs/pi-install-result.txt.

## Layout
| Partition | Size | Filesystem | Purpose |
| --- | --- | --- | --- |
| 1 | 20 GiB | exFAT PennyKey | Shared Windows/Android/Linux files |
| 2 | 1 GiB | FAT32 PENNYPIBOOT | Pi boot files installed |
| 3 | 1 GiB | FAT32 PENNYEFI | PC EFI reserved, no PC bootloader installed |
| 4 | 32 GiB | ext4 PENNYPIROOT | Fresh Pi OS installed |
| 5 | ~65.5 GiB | Unformatted Linux type | PC root reserved |

## Next step: physical Pi boot test
When the user is ready, finish active SD-card setup work, shut down Pi normally, remove power, remove its existing SD card, connect PennyKey to a blue USB 3 port and power on. Existing SD contents remain unchanged. Expect the stock desktop first-run wizard; choose account/password/network there. Report whether the desktop loads. If boot fails, inspect the actual boot screen and USB boot firmware/order rather than reformatting.

## Limits and pending work
- No physical boot success claimed. Pi firmware USB boot capability and this GPT layout remain to be verified on the device.
- No SSH/key setup or desktop customization applied; automatic approval rejected those extras, and the successful script omitted them.
- Wallpapers remain in repository: thHZP.png lock screen; xd8bu.png desktop wallpaper. Permanent configuration and logout/reboot tests pending.
- PC OS installation, Penny apps, emulators/controllers/saves, ComfyUI and future Pi 5/NVIDIA laptop tests pending.
- Existing Pi SD-card RetroArch/controller setup was not accessed, cloned or modified.
- Compressed/extracted image files remain under Ubuntu /var/tmp/pennykey for this installation stage. They are not in Git.
