# Architecture Overview

## Hyper-V Networks

### Windows Enterprise Lab

```text
Network: 10.10.10.0/24
Switch: EnterpriseLabNet
Type: Internal Hyper-V switch
```

| VM | IP | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | AD DS, DNS, DHCP, GPO, SMB |
| storage-vm | 10.10.10.20 | iSCSI Target Server |
| backup-vm | 10.10.10.30 | Veeam Backup Server |
| win-client-vm | 10.10.10.100 | Domain client |

### Linux / Cloud Lab

```text
Network: 192.168.0.0/24
```

| VM | IP | Role |
|---|---:|---|
| api-vm | 192.168.0.110 | FastAPI |
| proxy-vm | 192.168.0.111 | Nginx reverse proxy |
| db-vm | 192.168.0.112 | PostgreSQL |
| monitoring-vm | 192.168.0.113 | Prometheus and Grafana |

## Windows Backup Flow

```text
\\dc-vm\LabShare
        ↓
Veeam Backup Job on backup-vm
        ↓
R:\Backups
        ↓
iSCSI LUN from storage-vm
```

## Storage Flow

```text
storage-vm
└── iSCSI Target Server
    ├── LabLUN01.vhdx       → win-client-vm → I:
    └── VeeamRepo01.vhdx    → backup-vm     → R:
```


## Service DNS Aliases

| Alias | Target | Purpose |
|---|---|---|
| `files.enterprise.lab` | `dc-vm.enterprise.lab` | SMB file share service |
| `storage.enterprise.lab` | `storage-vm.enterprise.lab` | iSCSI storage service |
| `backup.enterprise.lab` | `backup-vm.enterprise.lab` | backup server |
| `veeam.enterprise.lab` | `backup-vm.enterprise.lab` | Veeam Backup & Replication service |

The main SMB path can now be documented as:

```text
\\files.enterprise.lab\LabShare
```
