# Project Summary - Enterprise Infrastructure Lab

## What Was Built

This project is a Hyper-V based enterprise infrastructure lab that combines Windows Server, Active Directory, SMB file sharing, iSCSI storage, Veeam Backup & Replication and Linux-to-Windows backup integration.

The lab simulates a small enterprise environment where Windows services provide identity, DNS, DHCP, file sharing, storage and backup capabilities, while a Linux VM writes backup data into the Windows-managed file share.

---

## Core Infrastructure

| Component | Implementation |
|---|---|
| Domain | `enterprise.lab` |
| Domain Controller | `dc-vm` |
| DNS/DHCP | Windows Server 2022 |
| File Share | `\\files.enterprise.lab\LabShare` |
| Storage | Windows iSCSI Target Server |
| Backup Server | Veeam Backup & Replication Community Edition |
| Backup Repository | `R:\Backups` on iSCSI-backed volume |
| Linux Integration | `db-vm` mounting Windows SMB share through CIFS |

---

## Main Workflows

### 1. Domain and Client Management

- Created Active Directory forest `enterprise.lab`
- Configured DNS and DHCP
- Joined Windows client to the domain
- Created OUs, users and security groups
- Applied GPOs to users and workstations
- Deployed mapped network drive through Group Policy

### 2. SMB File Share

- Created `LabShare` on the domain controller
- Configured NTFS and share permissions
- Verified access from domain user and backup server
- Added DNS alias `files.enterprise.lab`

### 3. iSCSI Storage

- Configured `storage-vm` as Windows iSCSI Target Server
- Created iSCSI LUNs for Windows client and Veeam repository
- Connected iSCSI targets from Windows initiators
- Formatted and verified iSCSI volumes

### 4. Veeam Backup and Restore

- Installed Veeam Backup & Replication Community Edition
- Configured an iSCSI-backed repository
- Created a file backup job for the SMB share
- Ran backup job successfully
- Deleted a test file
- Restored the file from backup
- Verified restored file content

### 5. Cross-Platform Linux-to-Windows Backup

- Connected Linux `db-vm` to the Windows enterprise network
- Resolved Windows DNS aliases from Linux
- Mounted `//files.enterprise.lab/LabShare` using CIFS
- Created Linux backup file on the Windows SMB share
- Ran Veeam backup job after Linux file creation
- Deleted and restored the Linux-generated file through Veeam
- Verified restored file from Windows

---

## Final Validation Evidence

The final health check validates:

- DNS aliases resolve correctly
- SMB share is reachable through `files.enterprise.lab`
- Linux backup file exists in the Windows share
- Veeam repository volume `R:` is healthy
- iSCSI session is connected and persistent
- Veeam services are running

Screenshot:

```text
diagrams/windows-server/71-final-lab-health-check.png
```

---

## Skills Demonstrated

- Windows Server administration
- Active Directory, DNS, DHCP
- Group Policy and OU design
- SMB and NTFS permissions
- iSCSI storage
- Veeam Backup & Replication
- Backup and restore operations
- Linux CIFS/SMB integration
- Cross-platform infrastructure workflow
- PowerShell validation and troubleshooting
- Technical documentation and runbook writing

---

## Why This Project Matters

This project demonstrates practical infrastructure administration beyond simple installation.

The lab proves that the environment works end-to-end:

```text
Linux workload
→ Windows SMB share
→ Veeam backup
→ iSCSI-backed repository
→ restore validation
```

That makes the project relevant for IT Administrator, Infrastructure Specialist, Systems Administrator, Windows Server Support, Backup Support and junior infrastructure/cloud roles.
