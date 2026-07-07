# 07 - Cross-Platform Linux-to-Windows Backup Integration

## Goal

This module connects the Linux/cloud part of the lab with the Windows infrastructure and Veeam backup workflow.

A Linux VM writes backup data to a Windows SMB share through the enterprise DNS alias `files.enterprise.lab`. The same SMB share is then protected by Veeam Backup & Replication, and the Linux-generated backup file is restored from Veeam.

---

## Architecture

```text
db-vm
Linux workload / backup file
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
File-level restore verification
```

---

## Screenshots

![db-vm Second Network Adapter](../../diagrams/windows-server/58-db-vm-second-network-adapter.png)

![Linux Enterprise Network Configuration](../../diagrams/windows-server/59-linux-enterprise-network-config.png)

![Linux DNS Resolution](../../diagrams/windows-server/60-linux-dns-resolution-enterprise-lab.png)

![Linux Connectivity to Windows Services](../../diagrams/windows-server/61-linux-connectivity-to-windows-services.png)

![AD Linux Backup Service Account](../../diagrams/windows-server/62-ad-linux-backup-service-account.png)

![Linux SMB Port 445 Check](../../diagrams/windows-server/63-linux-smb-port-445-check.png)

![Linux SMB Share Mounted](../../diagrams/windows-server/64-linux-smb-share-mounted.png)

![Linux Backup File Created](../../diagrams/windows-server/65-linux-backup-file-created.png)

![Windows Sees Linux Backup File](../../diagrams/windows-server/66-windows-linux-backup-file-visible.png)

![Veeam Backup Job with Linux File](../../diagrams/windows-server/67-veeam-backup-job-with-linux-file-success.png)

![Linux Backup File Deleted Before Restore](../../diagrams/windows-server/68-linux-backup-file-deleted-before-restore.png)

![Veeam Restore Browser with Linux Backup File](../../diagrams/windows-server/69-veeam-linux-backup-file-restore-browser.png)

![Linux Backup File Restore Verified](../../diagrams/windows-server/70-veeam-linux-backup-file-restore-success.png)

---

## Result

The cross-platform backup workflow was completed successfully:

```text
Linux db-vm
→ Windows SMB share through files.enterprise.lab
→ Linux backup file created
→ File visible from Windows
→ Veeam backup job completed successfully
→ File deleted
→ File restored from Veeam
→ Restore verified from Windows
```
