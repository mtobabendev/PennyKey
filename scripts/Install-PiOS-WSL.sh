#!/usr/bin/env bash
set -euo pipefail
cd /var/tmp/pennykey
boot_uuid=a01eec10-2c8a-4b26-91bc-8e8d92947201
root_uuid=c34f54dc-90f0-4f25-bc48-32243300d422
boot=$(blkid -t PARTUUID="$boot_uuid" -o device)
root=$(blkid -t PARTUUID="$root_uuid" -o device)
disk=/dev/$(lsblk -no PKNAME "$root")
[[ "$boot" == "${disk}2" && "$root" == "${disk}4" ]]
[[ $(blockdev --getsize64 "$disk") == 128320801792 ]]
[[ $(blockdev --getsize64 "$root") == 34359738368 ]]
[[ $(blkid -s PARTUUID -o value "${disk}1") == 1358da45-6a02-4a4f-a75b-ebd22b7bcef2 ]]
[[ $(blkid -s PARTUUID -o value "${disk}5") == db99bc11-9ba5-4e7e-bf7d-bc8a79ef7195 ]]
[[ -z $(findmnt -rn -S "$root") && -z $(findmnt -rn -S "$boot") ]]
[[ -z $(blkid -s TYPE -o value "$root" || true) ]]
sfdisk --dump "$disk" > partition-table-before.txt
mkdir -p shared-check target-root target-boot
mount -o ro "${disk}1" shared-check
(cd shared-check; find . -type f -exec sha256sum {} +) > shared-before.sha256
umount shared-check
loop=$(cat source-loop)
[[ -f source-root/etc/os-release && -f source-boot/kernel8.img ]]
[[ $(blockdev --getsize64 "${loop}p2") -lt $(blockdev --getsize64 "$root") ]]
printf 'Writing fresh Pi root filesystem to %s only.\n' "$root"
dd if="${loop}p2" of="$root" bs=4M conv=fsync status=progress
set +e
e2fsck -f -p "$root"
rc=$?
set -e
[[ $rc -le 1 ]]
resize2fs "$root"
e2label "$root" PENNYPIROOT
mount "$root" target-root
mount "$boot" target-boot
rsync -rlt --no-perms --no-owner --no-group source-boot/ target-boot/
python3 - <<'PY'
from pathlib import Path
boot=Path('target-boot'); root=Path('target-root')
p=boot/'cmdline.txt'
a=[v for v in p.read_text().split() if v!='resize']
a=['root=PARTUUID=c34f54dc-90f0-4f25-bc48-32243300d422' if v.startswith('root=') else v for v in a]
p.write_text(' '.join(a)+'\n')
f=root/'etc/fstab'
s=f.read_text().replace('PARTUUID=36f6e378-01','PARTUUID=a01eec10-2c8a-4b26-91bc-8e8d92947201').replace('PARTUUID=36f6e378-02','PARTUUID=c34f54dc-90f0-4f25-bc48-32243300d422')
s+='PARTUUID=1358da45-6a02-4a4f-a75b-ebd22b7bcef2 /media/PennyKey exfat defaults,nofail,x-systemd.device-timeout=10,uid=1000,gid=1000,umask=0022 0 0\n'
f.write_text(s)
(root/'media/PennyKey').mkdir(parents=True,exist_ok=True)
(root/'etc/cloud/cloud.cfg.d/98-pennykey-preserve-partitions.cfg').write_text('growpart:\n  mode: off\nresize_rootfs: false\n')
PY
sync
(cd source-boot; find . -type f ! -name cmdline.txt -exec sha256sum {} +) > boot-source.sha256
(cd target-boot; sha256sum --quiet -c ../boot-source.sha256)
grep -q "root=PARTUUID=$root_uuid" target-boot/cmdline.txt
! grep -qw resize target-boot/cmdline.txt
grep -q "$boot_uuid" target-root/etc/fstab
grep -q 'ID=raspbian\|ID=debian' target-root/etc/os-release
umount target-boot target-root
sfdisk --dump "$disk" > partition-table-after.txt
cmp partition-table-before.txt partition-table-after.txt
mount -o ro "${disk}1" shared-check
(cd shared-check; sha256sum --quiet -c ../shared-before.sha256)
umount shared-check
printf 'INSTALL COPY VERIFIED: Pi boot/root written; partition table and shared files unchanged. Physical boot and desktop setup pending.\n'
lsblk -b -o NAME,SIZE,FSTYPE,LABEL,PARTUUID "$disk"