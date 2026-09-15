# Error log
## 2026-09-14 to 2026-09-15: partitioning interruption
- Windows rejected Set-Partition -NoDefaultDriveLetter on this removable USB with Not Supported, after the shared exFAT and Pi FAT32 partitions were created.
- Resumed from those two partitions without repeating the wipe. Omitted the unsupported optional setting; used DiskPart for the PC EFI type and verified it.
- User screenshots show Codex usage-limit notices interrupting the conversation while the completion operation was pending, including a further usage-limit notice after the user requested an error-log entry. This delayed delivery of the result and left the user without a confirmed completion status.
- These screenshots show usage-limit interruptions, not a content-policy refusal. No claim is made about billing correctness or the underlying limit calculation.
- On resumption, the saved script result reported SUCCESS and Windows read/write passed. A single read-only partition listing confirmed all five partitions. No new format was performed.
- Assistant process errors: included an optional unsupported operation in the critical partitioning sequence; repeatedly polled without useful progress; did not deliver the completion result or persist the final status before the interruption.
- Recovery: saved actual result, updated STATUS.md, and pushed the stage record. Android verification remains required. No OS is installed yet.
