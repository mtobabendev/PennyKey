# Pi OS installation source
- Official page: https://www.raspberrypi.com/software/operating-systems/
- Image: https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2026-06-19/2026-06-18-raspios-trixie-arm64.img.xz
- Edition: Raspberry Pi OS 64-bit desktop, Debian 13 Trixie, released 2026-06-18.
- SHA256: 123287c05f27b0eebd8f65456f6369b8f6635fa50a3d440a4f9f6223bf58c8e2
- Download checksum verified in Ubuntu WSL on 2026-09-15.
- Keep the image outside Git. Never write the entire image onto the prepared USB.
- Intended destinations: Pi boot partition UUID a01eec10-2c8a-4b26-91bc-8e8d92947201; Pi root partition UUID c34f54dc-90f0-4f25-bc48-32243300d422.
- Preserve shared partition 1358da45-6a02-4a4f-a75b-ebd22b7bcef2, PC EFI 8ac4e0da-8d9f-4ccf-8036-c4ac18b7ef40 and PC root db99bc11-9ba5-4e7e-bf7d-bc8a79ef7195.
