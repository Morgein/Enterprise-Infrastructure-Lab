# 03 - iSCSI Storage

## Goal

Simulate enterprise block storage by configuring Windows Server iSCSI Target Server and connecting Windows clients as iSCSI initiators.

## Storage Server

```text
Server: storage-vm.enterprise.lab
IP: 10.10.10.20
Role: iSCSI Target Server
Data drive: E:
```

## iSCSI LUNs

| Virtual Disk | Target | Initiator | Client Drive |
|---|---|---|---|
| `E:\iSCSI\LabLUN01.vhdx` | `lab-iscsi-target` | `win-client-vm / 10.10.10.100` | `I:` |
| `E:\iSCSI\VeeamRepo01.vhdx` | `veeam-repo-target` | `backup-vm / 10.10.10.30` | `R:` |

## Implemented

- iSCSI Target Server role installed
- iSCSI virtual disk created
- iSCSI target created
- Initiator access restricted by IP
- Client connected to target
- Disk initialized and formatted as NTFS
- File write test completed

## Verification Commands

On `storage-vm`:

```powershell
Get-WindowsFeature FS-iSCSITarget-Server
Get-Service WinTarget
Get-IscsiVirtualDisk | Format-List Path,Size
Get-IscsiServerTarget | Format-List TargetName,InitiatorIds,Status
```

On the client:

```powershell
Test-NetConnection 10.10.10.20 -Port 3260
Get-IscsiTargetPortal
Get-IscsiTarget
Get-IscsiSession
Get-Disk
Get-Volume
```

## Screenshots

![Storage VM in Servers OU](../../diagrams/windows-server/32-storage-vm-server-ou.png)

![iSCSI Role Installed](../../diagrams/windows-server/33-iscsi-role-installed.png)

![iSCSI Virtual Disk](../../diagrams/windows-server/34-iscsi-virtual-disk.png)

![iSCSI Target Created](../../diagrams/windows-server/35-iscsi-target-created.png)

![iSCSI Target Connected](../../diagrams/windows-server/36-iscsi-target-connected.png)

![Client iSCSI Portal](../../diagrams/windows-server/37-client-iscsi-portal-target.png)

![Client iSCSI Session](../../diagrams/windows-server/38-client-iscsi-session.png)

![Client iSCSI Disk Volume](../../diagrams/windows-server/39-client-iscsi-disk-volume.png)

![iSCSI Write Test](../../diagrams/windows-server/40-iscsi-write-test.png)
