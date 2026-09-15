# Destructive: run only for the explicitly authorized PennyKey partitioning stage.
#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'
$resultPath = Join-Path $env:TEMP 'pennykey-partition-result.txt'
try {
$d = Get-Disk | Where-Object { $_.BusType -eq 'USB' -and $_.FriendlyName -eq 'Samsung Flash Drive' -and $_.SerialNumber.Trim() -eq 'AA00000000000489' }
if (@($d).Count -ne 1 -or $d.Size -ne 128320801792 -or $d.IsBoot -or $d.IsSystem) { throw 'USB identity check failed; no changes made.' }
$d | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
$d = Get-Disk -Number $d.Number
if ($d.PartitionStyle -eq 'RAW') { Initialize-Disk -Number $d.Number -PartitionStyle GPT | Out-Null }
$shared = New-Partition -DiskNumber $d.Number -Size 20GB -AssignDriveLetter
$shared | Format-Volume -FileSystem exFAT -NewFileSystemLabel PennyKey -Force -Confirm:$false | Out-Null
$piBoot = New-Partition -DiskNumber $d.Number -Size 1GB -AssignDriveLetter
$piBoot | Format-Volume -FileSystem FAT32 -NewFileSystemLabel PENNYPIBOOT -Force -Confirm:$false | Out-Null
$piBoot | Remove-PartitionAccessPath -AccessPath ('{0}:\' -f $piBoot.DriveLetter)
# NoDefaultDriveLetter is unsupported on this removable drive; omit.
$pcBoot = New-Partition -DiskNumber $d.Number -Size 1GB -AssignDriveLetter
$pcBoot | Format-Volume -FileSystem FAT32 -NewFileSystemLabel PENNYEFI -Force -Confirm:$false | Out-Null
$pcBoot | Remove-PartitionAccessPath -AccessPath ('{0}:\' -f $pcBoot.DriveLetter)
$dp = Join-Path $env:TEMP 'penny-efi-type.txt'
@("select disk $($d.Number)", "select partition $($pcBoot.PartitionNumber)", 'set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b override') | Set-Content $dp
$dpOut = diskpart /s $dp | Out-String
if ((Get-Partition -DiskNumber $d.Number -PartitionNumber $pcBoot.PartitionNumber).GptType -ne '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}') { throw "EFI type change failed: $dpOut" }
New-Partition -DiskNumber $d.Number -Size 32GB -GptType '{0fc63daf-8483-4772-8e79-3d69d8477de4}' | Out-Null
New-Partition -DiskNumber $d.Number -UseMaximumSize -GptType '{0fc63daf-8483-4772-8e79-3d69d8477de4}' | Out-Null
$root = '{0}:\' -f $shared.DriveLetter
$test = Join-Path $root 'penny-verification.txt'
Set-Content -LiteralPath $test -Value 'PennyKey shared partition verified'
if ((Get-Content -LiteralPath $test -Raw).Trim() -ne 'PennyKey shared partition verified') { throw 'Shared partition read-back failed.' }
Remove-Item -LiteralPath $test
$parts = Get-Partition -DiskNumber $d.Number
if (@($parts).Count -ne 5) { throw 'Unexpected partition count.' }
$report = $parts | Select-Object PartitionNumber,DriveLetter,Size,GptType | Format-Table -AutoSize | Out-String
$volume = Get-Volume -DriveLetter $shared.DriveLetter | Select-Object DriveLetter,FileSystemLabel,FileSystem,Size,SizeRemaining,HealthStatus | Format-List | Out-String
('SUCCESS: partition creation and Windows shared read/write test passed. Linux roots allocated but not formatted. No operating systems installed.' + $report + $volume) | Set-Content -LiteralPath $resultPath
} catch {
('FAILED: ' + $_.Exception.Message + '. Stop and inspect the specific failure before retrying; partial changes may exist.') | Set-Content -LiteralPath $resultPath
exit 1
}


