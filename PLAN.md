# PennyKey plan
## Objective
Portable persistent Linux for compatible Intel/AMD PCs and Raspberry Pi, with shared Windows/Android/Linux file transfer, Penny applications, emulators through PS1, and ComfyUI on suitable hardware.

## Agreed requirements
- Samsung USB: 128320801792 bytes, about 119.5 GiB usable.
- First partition: 20 GiB exFAT, label PennyKey, Microsoft Basic Data GPT type; test Windows and actual Android phones with USB OTG.
- Pi boot: 1 GiB FAT32, positioned before the PC EFI partition so it is the first FAT boot candidate.
- PC boot: 1 GiB FAT32 EFI System Partition. Initial PC target: x86-64 UEFI; legacy BIOS not promised.
- Pi root: 32 GiB Linux filesystem partition, ext4 formatting during Linux installation.
- PC root: remaining space, Linux filesystem partition, ext4 formatting during Linux installation.
- Separate ARM64 Pi and x86-64 PC installations; matching lightweight desktop experience, persistent settings.
- Pi 4 4 GB initial test device; later Pi 5 16 GB verification. Current PC initial test, daughter's NVIDIA Dell laptop later; identify exact GPU then.
- No universal Mac/Android boot claim. Android is a required shared-storage client.
- Penny software, launchers and configuration backed up here.
- Selected emulators through PS1, controller and save testing; exclude Dreamcast, PSP and newer consoles. Individual older systems may have performance limitations.
- ComfyUI PC first, hardware-appropriate models and GPU dependencies; Pi can use remote ComfyUI. Local Pi generation is experimental.
- Lock screen: thHZP.png. Wallpaper: xd8bu.png. SHA256 matches user attachments exactly. Configure permanent system assets on both installations and verify logout/login/reboot persistence. Desktop/locker selection must support these requirements.

## Stages
1. Repository requirements and working rules; commit and push.
2. Partition USB; Windows read/write and Android read/write checkpoint before Linux installation.
3. Pi installation; boot without SD, verify persistence/shared access.
4. PC installation; boot this PC, verify persistence/shared access.
5. Penny applications and permanent visual configuration.
6. Emulators through PS1 and controller/save tests.
7. ComfyUI basic generation, then NVIDIA laptop test.

## Backup
Git tracks source, setup scripts, configs, workflows, version/download references, instructions and verified progress. Full disk images, models, ROM libraries and personal files require separate backup. GitHub is not a full USB backup. Commit and push each completed stage.

## Boot reference
https://www.raspberrypi.com/documentation/computers/raspberry-pi.html
https://github.com/raspberrypi/documentation/blob/master/documentation/asciidoc/computers/config_txt/autoboot.adoc
Pi USB boot order/firmware and the partition arrangement require physical boot verification. Creating partitions alone proves no boot compatibility.
