# Enterprise Infrastructure Lab

A practical enterprise infrastructure lab built on Hyper-V.  
The project demonstrates Windows Server administration, Active Directory, DNS, DHCP, Group Policy, SMB file sharing, iSCSI storage, Veeam backup and restore validation, plus a Linux/cloud automation stack.

This repository is designed as a portfolio project for roles such as:

- IT Administrator
- Infrastructure Specialist
- Systems Administrator
- Junior Cloud / DevOps Engineer
- Backup / Storage / Windows Server Support Engineer

---

## Current Lab Status

| Area | Status | Main Result |
|---|---:|---|
| Active Directory Domain Services | Done | `enterprise.lab` domain created |
| DNS | Done | AD-integrated DNS zone configured |
| DHCP | Done | `10.10.10.0/24` scope configured |
| Domain Client | Done | Windows client joined to domain |
| OU / Groups / GPO | Done | Users, workstations and GPO baselines configured |
| SMB File Share | Done | `\\dc-vm\LabShare` with domain permissions |
| Mapped Network Drive | Done | `Z:` deployed through GPO |
| iSCSI Storage | Done | iSCSI LUN connected and verified |
| Veeam Backup | Done | SMB share backup job completed successfully |
| Veeam Restore | Done | Deleted file restored and verified |
| Linux / Cloud Lab | In progress | FastAPI, PostgreSQL, Nginx, Prometheus, Grafana, Ansible |

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| `dc-vm` | `10.10.10.10` | AD DS, DNS, DHCP, GPO, SMB file share |
| `storage-vm` | `10.10.10.20` | Windows Server iSCSI Target Server |
| `backup-vm` | `10.10.10.30` | Veeam Backup & Replication Community Edition |
| `win-client-vm` | `10.10.10.100` | Domain client, mapped drive, iSCSI initiator test |
| `api-vm` | `192.168.0.110` | FastAPI application |
| `proxy-vm` | `192.168.0.111` | Nginx reverse proxy |
| `db-vm` | `192.168.0.112` | PostgreSQL |
| `monitoring-vm` | `192.168.0.113` | Prometheus and Grafana |

---

## Core Windows Infrastructure

```text
Domain: enterprise.lab
NetBIOS: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
DNS/DHCP Server: 10.10.10.10
SMB Share: \\dc-vm\LabShare
Mapped Drive: Z:
Storage Server: storage-vm
iSCSI Target: lab-iscsi-target
Client iSCSI Volume: I: / ISCSI-LUN
Veeam Server: backup-vm
Veeam Repository Volume: R: / VEEAM-REPO
Veeam Repository Path: R:\Backups
Veeam Backup Source: \\dc-vm\LabShare
```

---

## Documentation Map

Start here:

- [Documentation index](docs/README.md)
- [Windows infrastructure overview](docs/windows/README.md)
- [Full Windows module report](docs/windows/full-report.md)

Main Windows modules:

1. [Active Directory, DNS and DHCP](docs/windows/01-active-directory-dns-dhcp.md)
2. [Domain Client, OU, GPO and SMB Share](docs/windows/02-domain-client-gpo-smb.md)
3. [iSCSI Storage](docs/windows/03-iscsi-storage.md)
4. [Veeam Backup and Restore](docs/windows/04-veeam-backup-restore.md)
5. [Validation Checklist](docs/windows/05-validation-checklist.md)

Runbooks:

- [AD, DNS and DHCP troubleshooting](docs/runbooks/ad-dns-dhcp-troubleshooting.md)
- [iSCSI troubleshooting](docs/runbooks/iscsi-troubleshooting.md)
- [Veeam restore procedure](docs/runbooks/veeam-restore-procedure.md)

Cloud/Linux part:

- [Linux and Cloud Lab overview](docs/cloud/README.md)

---

## Repository Structure

```text
.
├── README.md
├── ansible/
│   ├── inventory.ini
│   ├── playbook.yml
│   └── group_vars/
├── app/
│   ├── app.py
│   ├── Dockerfile
│   └── docker-compose.yml
├── docs/
│   ├── README.md
│   ├── architecture.md
│   ├── windows/
│   │   ├── README.md
│   │   ├── 01-active-directory-dns-dhcp.md
│   │   ├── 02-domain-client-gpo-smb.md
│   │   ├── 03-iscsi-storage.md
│   │   ├── 04-veeam-backup-restore.md
│   │   ├── 05-validation-checklist.md
│   │   └── full-report.md
│   ├── runbooks/
│   └── cloud/
├── diagrams/
│   ├── README.md
│   └── windows-server/
├── monitoring/
├── nginx/
└── scripts/
    ├── backup-postgres.sh
    ├── restore-postgres.sh
    └── windows/
        └── lab-health-check.ps1
```

---

## Skills Demonstrated

### Windows Server / Infrastructure

- Active Directory Domain Services deployment
- AD-integrated DNS
- DHCP scope configuration
- Domain join troubleshooting
- OU and security group design
- Group Policy Objects
- SMB file share permissions
- Mapped network drives through GPO
- iSCSI Target and Initiator configuration
- Veeam Backup & Replication Community Edition
- Backup repository configuration
- File backup job creation
- File-level restore validation

### Linux / Cloud / Automation

- Docker and Docker Compose
- FastAPI application deployment
- PostgreSQL service deployment
- Nginx reverse proxy
- Prometheus and Grafana monitoring
- Ansible automation
- Basic backup and restore scripting

---

## Current Best Portfolio Story

The strongest completed part of this lab is the Windows infrastructure and backup workflow:

```text
Active Directory domain
→ DHCP and DNS
→ domain client
→ OU/GPO/security groups
→ SMB file share
→ mapped network drive
→ iSCSI storage
→ Veeam repository
→ file backup job
→ file deletion
→ restore from backup
→ restore verification
```

This shows not only installation, but also operational validation.

---

## Next Improvements

- Add DNS aliases for internal services such as Grafana and API
- Add monitoring screenshots for Windows services
- Add operational runbooks for common incidents
- Add Hyper-V VM backup test with Veeam
- Add a final architecture diagram
- Add a LinkedIn/GitHub project summary
