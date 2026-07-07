# Architecture Overview


## Cross-Platform Backup Flow

```text
db-vm
10.10.10.40
        ↓
CIFS mount
//files.enterprise.lab/LabShare
        ↓
Windows SMB share
\\files.enterprise.lab\LabShare\linux-backups
        ↓
Veeam file backup job
backup-vm
        ↓
iSCSI-backed repository
R:\Backups
        ↓
Restore verification
```
