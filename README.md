# Enterprise Infrastructure Lab

## Project Overview

This lab demonstrates the design, deployment and validation of a small enterprise infrastructure environment using Windows Server, Active Directory, Group Policy, SMB file sharing, iSCSI storage, Veeam Backup & Replication, and Linux-to-Windows backup integration.

The project focuses on practical infrastructure administration tasks, operational verification, troubleshooting and backup/restore testing in a Hyper-V based lab environment.

![Enterprise Infrastructure Lab Architecture](diagrams/enterprise-infrastructure-architecture.svg)

---

## Current Lab Status

| Area | Status | Main Result |
|---|---:|---|
| Active Directory Domain Services | Done | `enterprise.lab` domain created |
| DNS | Done | AD-integrated DNS zone configured |
| DHCP | Done | `10.10.10.0/24` scope configured |
| Domain Client | Done | Windows client joined to domain |
| OU / Groups / GPO | Done | Users, workstations and GPO baselines configured |
| SMB File Share | Done | `\\files.enterprise.lab\LabShare` accessible |
| Mapped Network Drive | Done | `Z:` deployed through GPO |
| iSCSI Storage | Done | Windows iSCSI LUNs connected and verified |
| Veeam Backup | Done | SMB share backup job completed successfully |
| Veeam Restore | Done | Deleted files restored and verified |
| DNS Aliases | Done | Enterprise-style service aliases created |
| Cross-Platform Backup | Done | Linux backup file written to Windows SMB share and restored through Veeam |
| Final Validation | Done | DNS, SMB, iSCSI and Veeam services verified together |

---

## Architecture Summary

| VM | IP Address | Role |
|---|---:|---|
| `dc-vm` | `10.10.10.10` | AD DS, DNS, DHCP, GPO, SMB file share |
| `storage-vm` | `10.10.10.20` | Windows Server iSCSI Target Server |
| `backup-vm` | `10.10.10.30` | Veeam Backup & Replication Community Edition |
| `db-vm` | `10.10.10.40` | Linux VM integrated with Windows SMB backup workflow |
| `win-client-vm` | `10.10.10.100` | Domain client, mapped drive and iSCSI initiator test |

---

## Service DNS Aliases

| Alias | Target | Purpose |
|---|---|---|
| `files.enterprise.lab` | `dc-vm.enterprise.lab` | SMB file share service |
| `storage.enterprise.lab` | `storage-vm.enterprise.lab` | iSCSI storage service |
| `backup.enterprise.lab` | `backup-vm.enterprise.lab` | Backup server |
| `veeam.enterprise.lab` | `backup-vm.enterprise.lab` | Veeam backup service |

---

## Validated End-to-End Workflows

### Windows Infrastructure

```text
Active Directory
→ DNS/DHCP
→ domain client
→ OU/GPO/security groups
→ SMB share
→ mapped network drive
```

### Storage and Backup

```text
storage-vm iSCSI Target
→ backup-vm iSCSI Initiator
→ R:\Backups Veeam repository
→ file backup job
→ file-level restore verification
```

### Cross-Platform Backup

```text
Linux db-vm
→ CIFS mount //files.enterprise.lab/LabShare
→ Linux backup file written to Windows SMB share
→ Veeam backup job
→ iSCSI-backed repository
→ file restored from Veeam
→ restore verified from Windows
```

---

## Documentation Map

- [Documentation index](docs/README.md)
- [Architecture overview](docs/architecture.md)
- [Project summary](PROJECT_SUMMARY.md)

Windows infrastructure modules:

1. [Active Directory, DNS and DHCP](docs/windows/01-active-directory-dns-dhcp.md)
2. [Domain Client, OU, GPO and SMB Share](docs/windows/02-domain-client-gpo-smb.md)
3. [iSCSI Storage](docs/windows/03-iscsi-storage.md)
4. [Veeam Backup and Restore](docs/windows/04-veeam-backup-restore.md)
5. [Validation Checklist](docs/windows/05-validation-checklist.md)
6. [DNS Aliases and Enterprise Naming](docs/windows/06-dns-aliases.md)
7. [Cross-Platform Linux-to-Windows Backup Integration](docs/windows/07-cross-platform-backup-integration.md)
8. [Final Validation and Architecture](docs/windows/08-final-validation-and-architecture.md)

Runbooks:

- [AD, DNS and DHCP troubleshooting](docs/runbooks/ad-dns-dhcp-troubleshooting.md)
- [iSCSI troubleshooting](docs/runbooks/iscsi-troubleshooting.md)
- [Veeam restore procedure](docs/runbooks/veeam-restore-procedure.md)

---

## Skills Demonstrated

- Windows Server 2022 administration
- Active Directory Domain Services
- DNS and DHCP
- Organizational Units and security groups
- Group Policy Objects
- SMB file sharing
- NTFS and share permissions
- Mapped network drives
- iSCSI Target and Initiator configuration
- Veeam Backup & Replication Community Edition
- File backup job creation
- File-level restore validation
- Linux CIFS/SMB integration
- Cross-platform backup workflow
- PowerShell validation
- Technical documentation and runbooks

---

## Final Result

This lab proves a complete infrastructure workflow:

```text
Windows domain services
+ Windows storage services
+ Veeam backup platform
+ Linux workload integration
+ verified backup and restore operations
```

The strongest part of the project is that each major component was not only installed, but also validated with commands, screenshots, restore tests and documentation.
