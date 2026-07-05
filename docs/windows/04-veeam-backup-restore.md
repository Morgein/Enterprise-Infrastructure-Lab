# 04 - Veeam Backup and Restore

## Goal

Configure Veeam Backup & Replication Community Edition and verify a full backup and restore workflow.

## Configuration

```text
Backup server: backup-vm.enterprise.lab
Backup server IP: 10.10.10.30
Veeam edition: Community Edition
Repository volume: R:
Repository label: VEEAM-REPO
Repository path: R:\Backups
Backup source: \\dc-vm\LabShare
Backup job: Backup LabShare to iSCSI Repository
Job type: File Backup
Schedule: Manual
Restore test file: veeam-source-test.txt
```

## Backup Flow

```text
\\dc-vm\LabShare
        ↓
Veeam Backup & Replication on backup-vm
        ↓
R:\Backups
        ↓
iSCSI LUN from storage-vm
```

## Restore Test

A source file was deleted from the SMB share and restored from the Veeam backup.

```text
Deleted file: \\dc-vm\LabShare\veeam-source-test.txt
Restore source: Veeam backup restore point
Restore destination: original location
Restore status: completed successfully
Verification: file exists again and content is readable
```

## Verification Commands

```powershell
Get-Volume
Get-IscsiSession
dir R:\
dir R:\Backups
dir "\\dc-vm\LabShare"
type "\\dc-vm\LabShare\veeam-source-test.txt"
```

## Screenshots

![Veeam Console Home](../../diagrams/windows-server/41-veeam-console-home.png)

![Veeam iSCSI Repository](../../diagrams/windows-server/42-veeam-iscsi-repository.png)

![Repository Volume](../../diagrams/windows-server/43-veeam-repository-volume.png)

![SMB File Share Source](../../diagrams/windows-server/44-veeam-smb-file-share-source.png)

![Backup Job](../../diagrams/windows-server/45-veeam-file-share-backup-job.png)

![Repository Files](../../diagrams/windows-server/46-veeam-repository-files.png)

![Source File Deleted](../../diagrams/windows-server/49-veeam-source-file-deleted.png)

![Restore Browser](../../diagrams/windows-server/50-veeam-file-restore-browser.png)

![Restore Verification](../../diagrams/windows-server/51-veeam-file-restore-success.png)

![Restore Completed](../../diagrams/windows-server/52-veeam-restore-completed-successfully.png)

![Restore History](../../diagrams/windows-server/53-veeam-restore-history.png)
