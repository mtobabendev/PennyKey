#Requires -RunAsAdministrator
$ErrorActionPreference='Stop'
try {
$d=Get-Disk -Number 1
if ($d.BusType -ne 'USB' -or $d.SerialNumber.Trim() -ne 'AA00000000000489' -or $d.Size -ne 128320801792 -or $d.IsBoot -or $d.IsSystem) { throw 'Identity mismatch' }
$p= @(Get-Partition -DiskNumber 1)
if ($p.Count -ne 2 -or $p[0].Size -ne 20GB -or $p[1].Size -ne 1GB) { throw 'Unexpected resume layout' }
$pc=New-Partition -DiskNumber 1 -Size 1GB -AssignDriveLetter
$pc | Format-Volume -FileSystem FAT32 -NewFileSystemLabel PENNYEFI -Force -Confirm:$false | Out-Null
$pc | Remove-PartitionAccessPath -AccessPath ('{0}:\' -f $pc.DriveLetter)
$dp=Join-Path $env:TEMP 'penny-efi-type.txt'
@("select disk 1", "select partition $($pc.PartitionNumber)", 'set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b override') | Set-Content $dp
$dpOut = diskpart /s $dp | Out-String
if ((Get-Partition -DiskNumber 1 -PartitionNumber $pc.PartitionNumber).GptType -ne '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}') { throw "EFI type change failed: $dpOut" }
New-Partition -DiskNumber 1 -Size 32GB -GptType '{0fc63daf-8483-4772-8e79-3d69d8477de4}' | Out-Null
New-Partition -DiskNumber 1 -UseMaximumSize -GptType '{0fc63daf-8483-4772-8e79-3d69d8477de4}' | Out-Null
Set-Content E:\penny-verification.txt 'PennyKey shared partition verified'
if ((Get-Content E:\penny-verification.txt -Raw).Trim() -ne 'PennyKey shared partition verified') { throw 'Read-back failed' }
Remove-Item E:\penny-verification.txt
$parts=@(Get-Partition -DiskNumber 1)
if ($parts.Count -ne 5) { throw 'Partition count mismatch' }
$r=$parts | Select-Object PartitionNumber,DriveLetter,Size,GptType | Format-Table -AutoSize | Out-String
$v=Get-Volume -DriveLetter E | Select-Object DriveLetter,FileSystemLabel,FileSystem,Size,SizeRemaining,HealthStatus | Format-List | Out-String
('SUCCESS: Windows read/write passed. Linux roots unformatted; no OS installed.'+$r+$v) | Set-Content (Join-Path $env:TEMP 'pennykey-partition-result.txt')
} catch { ($_ | Out-String) | Set-Content (Join-Path $env:TEMP 'pennykey-partition-result.txt'); exit 1 }
