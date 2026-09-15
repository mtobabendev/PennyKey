# PennyKey working rules
Before acting, read AGENTS.md, PLAN.md, and STATUS.md. Continue only the current agreed stage. Distinguish proposed, executed, and verified work. Do not repeat completed checks without a specific reason. Record results and push completed changes. Never claim universal hardware compatibility or successful installation without verification.

- Execute agreed work and commit/push automatically unless the user says otherwise. Do not request separate push approval.
- One stage at a time, with focused verification. Investigate specific failures only.
- Verify the physical USB by bus, model, serial, capacity, and non-system status immediately before destructive work. Never use a drive letter as the sole identity.
- User authorized erasing and partitioning the Samsung USB. Do not modify host OS disks.
- Report when UAC or physical device testing requires the user.
- Preserve existing repository assets. Keep secrets, personal data, OS images, AI models, ROMs and BIOS dumps out of Git.
- Record failures honestly. An allocated Linux partition is not a formatted or bootable Linux installation.
- Do not overwrite the whole USB with an OS image after creating the shared partition. Install into the intended partitions.
