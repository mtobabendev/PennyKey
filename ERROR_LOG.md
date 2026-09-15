# Error log
## 2026-09-14 to 2026-09-15: partitioning interruption
- Windows rejected Set-Partition -NoDefaultDriveLetter on this removable USB with Not Supported, after the shared exFAT and Pi FAT32 partitions were created.
- Resumed from those two partitions without repeating the wipe. Omitted the unsupported optional setting; used DiskPart for the PC EFI type and verified it.
- User screenshots show Codex usage-limit notices interrupting the conversation while the completion operation was pending, including a further usage-limit notice after the user requested an error-log entry. This delayed delivery of the result and left the user without a confirmed completion status.
- These screenshots show usage-limit interruptions, not a content-policy refusal. No claim is made about billing correctness or the underlying limit calculation.
- On resumption, the saved script result reported SUCCESS and Windows read/write passed. A single read-only partition listing confirmed all five partitions. No new format was performed.
- Assistant process errors: included an optional unsupported operation in the critical partitioning sequence; repeatedly polled without useful progress; did not deliver the completion result or persist the final status before the interruption.
- Recovery: saved actual result, updated STATUS.md, and pushed the stage record. Android verification remains required. No OS is installed yet.

## 2026-09-15: unnecessary SSH friction and unclear installation handoff
- User reports earlier assistant advice was to defer SSH setup during flashing, resulting in avoidable setup work now. That earlier advice has not been independently retrieved in this task; preserve the report as reported.
- SSH on 192.168.95.71 was already running and accepted password authentication. Key authentication failed; enabling SSH again was not the missing step.
- Assistant asked user to transfer a long public key manually, then supplied a laptop-side transfer method. User's pasted command contained backslash escapes; subsequent key authentication still failed. No remote Pi session was established.
- Assistant failed to explain the installation method and USB handoff before pursuing remote access, creating confusion and interrupting the user's emulator work.
- Clarification: intended installation is a fresh official Pi OS image deployed into USB Pi boot/root partitions, not cloning the user's active SD system. Do not clone the SD card or modify its RetroArch/controller setup.
- Current state: no OS installed on USB; shared Windows/Android storage and five-partition layout remain verified. Do not run more access checks or install host USB tooling until the installation route is clearly agreed with the user.

## 2026-09-15: Windows-side installation retry
- Automatic approval review rejected an initial combined script because it included SSH enablement/key installation and extra configuration. It did not execute.
- Removed those extras. The next attempt was rejected because the approval service reported a usage limit; it did not execute.
- User explicitly requested retry. The reduced script was approved, then stopped before writes because WSL had lost its USB attachment and source mounts during the interruption.
- Recovery: kept the Ubuntu VM running with a temporary helper, reattached Samsung USB, restored source mounts. Pi root write began successfully. No further SSH setup needed for this installation.

## Recovery outcome
The reduced Windows-side Pi installation completed successfully. Source checksum, boot-file copy, filesystem check, partition table preservation, and shared-file preservation passed. USB returned from WSL. Physical boot remains pending; no changes were made to the active Pi SD card.
