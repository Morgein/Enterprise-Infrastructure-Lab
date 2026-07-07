# Architecture Overview

## Final Architecture Diagram

![Enterprise Infrastructure Lab Architecture](../diagrams/enterprise-infrastructure-architecture.svg)

Mermaid source:

```mermaid
flowchart LR
    subgraph H["Hyper-V Host"]
        subgraph E["EnterpriseLabNet — 10.10.10.0/24"]
            DC["dc-vm<br/>10.10.10.10<br/>AD DS · DNS · DHCP · GPO<br/>SMB: files.enterprise.lab"]
            ST["storage-vm<br/>10.10.10.20<br/>iSCSI Target Server<br/>LabLUN01 + VeeamRepo01"]
            BK["backup-vm<br/>10.10.10.30<br/>Veeam Backup & Replication CE<br/>Repository: R:\\Backups"]
            CL["win-client-vm<br/>10.10.10.100<br/>Domain client<br/>Z: mapped drive · I: iSCSI disk"]
            DB["db-vm<br/>10.10.10.40<br/>Linux workload<br/>CIFS mount: /mnt/labshare"]
        end
    end

    DC -->|"DNS aliases<br/>files · storage · backup · veeam"| DB
    DC -->|"SMB share<br/>\\\\files.enterprise.lab\\LabShare"| CL
    DC -->|"SMB share<br/>\\\\files.enterprise.lab\\LabShare\\linux-backups"| DB
    ST -->|"iSCSI LUN<br/>LabLUN01.vhdx"| CL
    ST -->|"iSCSI LUN<br/>VeeamRepo01.vhdx"| BK
    BK -->|"File backup job<br/>Backup LabShare to iSCSI Repository"| DC
    BK -->|"Restore verification<br/>Windows + Linux backup files"| DC
```

---

## Network

```text
EnterpriseLabNet: 10.10.10.0/24
```

| VM | IP Address | Role |
|---|---:|---|
| `dc-vm` | `10.10.10.10` | AD DS, DNS, DHCP, GPO, SMB |
| `storage-vm` | `10.10.10.20` | iSCSI Target Server |
| `backup-vm` | `10.10.10.30` | Veeam Backup Server |
| `db-vm` | `10.10.10.40` | Linux workload integrated with SMB/Veeam workflow |
| `win-client-vm` | `10.10.10.100` | Domain client and iSCSI test client |

---

## Service DNS Aliases

| Alias | Target | Purpose |
|---|---|---|
| `files.enterprise.lab` | `dc-vm.enterprise.lab` | SMB file share service |
| `storage.enterprise.lab` | `storage-vm.enterprise.lab` | iSCSI storage service |
| `backup.enterprise.lab` | `backup-vm.enterprise.lab` | backup server |
| `veeam.enterprise.lab` | `backup-vm.enterprise.lab` | Veeam backup service |

---

## Backup Flow

```text
\\files.enterprise.lab\LabShare
        ↓
Veeam file backup job
        ↓
backup-vm
        ↓
R:\Backups
        ↓
iSCSI LUN from storage-vm
```

---

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
        ↓
iSCSI-backed repository
R:\Backups
        ↓
Restore verification
```
