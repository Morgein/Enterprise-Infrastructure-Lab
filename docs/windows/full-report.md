# Windows Server Active Directory, DNS, DHCP, Domain Client, GPO, File Share, iSCSI and Veeam Backup Module

## Goal

This module adds a Windows Server infrastructure component to the Enterprise Infrastructure Lab.

The goal is to practice common enterprise infrastructure administration tasks with Windows Server 2022, Active Directory Domain Services, DNS, DHCP, domain controller configuration, domain user management, Windows client domain join, Organizational Units, security groups, Group Policy Objects, SMB file sharing, mapped network drives, iSCSI storage and operational verification.

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, AD DS, DNS, DHCP, GPO management, SMB file share |
| storage-vm | 10.10.10.20 | Windows Server 2022, iSCSI Target Server |
| win-client-vm | 10.10.10.100 | Windows client joined to `enterprise.lab`, SMB mapped drive client, iSCSI Initiator |

```text
Hyper-V switch: EnterpriseLabNet
Network: 10.10.10.0/24
Domain Controller IP: 10.10.10.10
Storage Server IP: 10.10.10.20
Client IP: 10.10.10.100
```

---

## Domain Configuration

```text
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
Domain Controller IP: 10.10.10.10
Storage Server: storage-vm.enterprise.lab
Domain client: win-client-vm
Domain user: testuser01@enterprise.lab
Helpdesk user: helpdesk01@enterprise.lab
```

---

## Implemented Components

- Windows Server 2022 Standard Evaluation with Desktop Experience
- Active Directory Domain Services role
- DNS Server role
- New AD forest: `enterprise.lab`
- Domain controller: `dc-vm`
- AD-integrated DNS zone: `enterprise.lab`
- DHCP Server role authorized in Active Directory
- DHCP IPv4 scope for `10.10.10.0/24`
- Windows client VM joined to `enterprise.lab`
- Domain users: `testuser01`, `helpdesk01`
- Organizational Unit structure for users, groups, servers, service accounts and workstations
- Security groups for IT/admin/helpdesk/workstation-user scenarios
- User and computer GPOs verified with `gpresult`
- Legal notice configured through Group Policy
- SMB share `LabShare`
- NTFS/share permissions for `GG-Workstation-Users`
- Network drive `Z:` mapped through Group Policy Preferences
- Successful file write test from the mapped drive as `testuser01`
- iSCSI Target Server role installed on `storage-vm`
- iSCSI virtual disk/LUN created on `E:\iSCSI\LabLUN01.vhdx`
- iSCSI target `lab-iscsi-target` created
- Initiator access restricted to `win-client-vm` by IP address `10.10.10.100`
- iSCSI Initiator configured on `win-client-vm`
- iSCSI session established from `win-client-vm` to `storage-vm`
- iSCSI disk initialized, formatted as NTFS and mounted as `I:`
- Successful iSCSI write test from the Windows client

---

## Active Directory and DNS Configuration

```text
Forest: enterprise.lab
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
DNS Server: 10.10.10.10
```

Expected DNS resolution:

```text
enterprise.lab -> 10.10.10.10
dc-vm.enterprise.lab -> 10.10.10.10
storage-vm.enterprise.lab -> 10.10.10.20
```

---

## DHCP Configuration

```text
DHCP Server: dc-vm.enterprise.lab
DHCP Server IP: 10.10.10.10
Scope name: EnterpriseLab Scope
Scope network: 10.10.10.0/24
Start range: 10.10.10.100
End range: 10.10.10.200
Subnet mask: 255.255.255.0
DNS server option: 10.10.10.10
DNS domain option: enterprise.lab
```

No default gateway option is configured yet because the current `EnterpriseLabNet` switch is an internal Hyper-V network.

---

## Domain User and Client Configuration

```text
User: testuser01
UPN: testuser01@enterprise.lab
Domain logon: ENTERPRISE\testuser01
OU: Enterprise Lab / Users

User: helpdesk01
UPN: helpdesk01@enterprise.lab
OU: Enterprise Lab / Users
Group: GG-Helpdesk

Client hostname: win-client-vm
Storage Server IP: 10.10.10.20
Client IP: 10.10.10.100
DHCP Server: 10.10.10.10
DNS Server: 10.10.10.10
DNS suffix: enterprise.lab
Domain: enterprise.lab
OU: Enterprise Lab / Workstations
```

---

## Organizational Unit Structure

```text
enterprise.lab
└── Enterprise Lab
    ├── Groups
    ├── Servers
    ├── Service Accounts
    ├── Users
    └── Workstations
```

Objects:

```text
Users:
- testuser01
- helpdesk01

Groups:
- GG-Helpdesk
- GG-IT-Admins
- GG-Workstation-Users

Workstations:
- WIN-CLIENT-VM
```

---

## Group Policy Configuration

### Workstation Security Baseline

Linked to:

```text
OU=Workstations,OU=Enterprise Lab,DC=enterprise,DC=lab
```

Implemented settings:

```text
- Legal notice before logon
- Windows Firewall baseline configuration
```

Verified with:

```powershell
gpresult /scope computer /r
```

Expected applied GPO:

```text
Workstation Security Baseline
```

### User Restrictions Baseline

Linked to:

```text
OU=Users,OU=Enterprise Lab,DC=enterprise,DC=lab
```

Implemented setting:

```text
- Prohibit access to Control Panel and PC settings
```

Verified with:

```powershell
gpresult /scope user /r
```

Expected applied GPO:

```text
User Restrictions Baseline
```

### User Drive Mapping

Linked to:

```text
OU=Users,OU=Enterprise Lab,DC=enterprise,DC=lab
```

Implemented setting:

```text
Drive letter: Z:
Path: \\dc-vm\LabShare
Action: Update
Label: LabShare
```

Verified with:

```powershell
gpresult /scope user /r
net use
dir Z:\
```

Expected mapped drive:

```text
Z: -> \\dc-vm\LabShare
```

---

## SMB File Share Configuration

```text
Share name: LabShare
Local path: C:\Shares\LabShare
UNC path: \\dc-vm\LabShare
Mapped drive: Z:
```

Share permissions:

```text
ENTERPRISE\Domain Admins          Full
ENTERPRISE\GG-Workstation-Users   Change
```

NTFS permissions:

```text
ENTERPRISE\Domain Admins          Full Control
ENTERPRISE\GG-Workstation-Users   Modify
NT AUTHORITY\SYSTEM               Full Control
```

A test file was created from the mapped drive as `testuser01`, verifying write access through the mapped drive.

---


## iSCSI Storage Configuration

The storage server `storage-vm` was configured as an iSCSI Target Server.

```text
iSCSI Target Server: storage-vm.enterprise.lab
iSCSI Target Server IP: 10.10.10.20
iSCSI data disk on storage-vm: E:
iSCSI virtual disk path: E:\iSCSI\LabLUN01.vhdx
iSCSI virtual disk size: 20 GB
iSCSI target name: lab-iscsi-target
Allowed initiator: IPAddress:10.10.10.100
iSCSI Initiator: win-client-vm
Client drive letter: I:
Client volume label: ISCSI-LUN
Client file system: NTFS
```

The iSCSI disk was connected from `win-client-vm`, initialized, formatted as NTFS and mounted as `I:`. A test file was written successfully to verify the storage path.

Conceptually, this simulates basic SAN-style block storage:

```text
storage-vm
└── iSCSI Target Server
    └── E:\iSCSI\LabLUN01.vhdx
        └── exported as lab-iscsi-target

win-client-vm
└── iSCSI Initiator
    └── connected to 10.10.10.20:3260
        └── disk mounted as I:
```

---

## iSCSI Verification Commands

On `storage-vm`:

```powershell
Get-WindowsFeature FS-iSCSITarget-Server
Get-Service WinTarget
Get-IscsiVirtualDisk | Format-List Path,Size
Get-IscsiServerTarget | Format-List TargetName,InitiatorIds,Status
```

Expected results:

```text
iSCSI Target Server: Installed
WinTarget: Running
Path: E:\iSCSI\LabLUN01.vhdx
Size: 21474836480
TargetName: lab-iscsi-target
InitiatorIds: IPAddress:10.10.10.100
Status: Connected
```

On `win-client-vm`:

```powershell
Test-NetConnection 10.10.10.20 -Port 3260
Get-IscsiTargetPortal
Get-IscsiTarget
Get-IscsiSession
Get-Disk
Get-Volume
dir I:\
```

Expected results:

```text
TcpTestSucceeded: True
TargetPortalAddress: 10.10.10.20
IsConnected: True
IsPersistent: True
Disk: 20 GB
DriveLetter: I
FileSystemLabel: ISCSI-LUN
FileSystemType: NTFS
iscsi-test.txt exists
```

---

## Verification Commands

### Active Directory and DNS verification

```powershell
whoami
Get-ADDomain | Select-Object DNSRoot,NetBIOSName,PDCEmulator
Get-Service DNS,NTDS
nslookup enterprise.lab
nslookup dc-vm.enterprise.lab
```

### DHCP verification

```powershell
Get-Service DHCPServer | Select-Object Status,Name,DisplayName
Get-DhcpServerInDC | Select-Object DnsName,IPAddress
Get-DhcpServerv4Scope | Select-Object ScopeId,Name,StartRange,EndRange,State
Get-DhcpServerv4OptionValue -ScopeId 10.10.10.0 | Select-Object OptionId,Name,Value
Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

### Client verification

```powershell
ipconfig /all
hostname
systeminfo | findstr /B /C:"Domain"
nltest /dsgetdc:enterprise.lab
whoami
```

### GPO verification

```powershell
gpupdate /force
gpresult /scope user /r
gpresult /scope computer /r
```

Expected applied GPOs:

```text
User settings:
- User Restrictions Baseline
- User Drive Mapping

Computer settings:
- Workstation Security Baseline
- Default Domain Policy
```

### File share and mapped drive verification

On the domain controller:

```powershell
Get-SmbShare LabShare
Get-SmbShareAccess -Name "LabShare"
icacls "C:\Shares\LabShare"
```

On the Windows client:

```powershell
net use
dir Z:\
"Created by testuser01 from mapped drive" | Out-File "Z:\testuser01-gpo-drive-test.txt"
dir Z:\
```

Expected results:

```text
Z: -> \\dc-vm\LabShare
readme.txt
testuser01-gpo-drive-test.txt
```

---

## Screenshots

### Server Manager with AD DS and DNS

![Server Manager AD DS and DNS](../../diagrams/windows-server/01-server-manager-ad-dns.png)

### Active Directory Domain

![Active Directory Domain](../../diagrams/windows-server/02-active-directory-domain.png)

### DNS Forward Lookup Zone

![DNS Forward Lookup Zone](../../diagrams/windows-server/03-dns-forward-zone.png)

### PowerShell AD and DNS Verification

![PowerShell AD DNS Verification](../../diagrams/windows-server/04-powershell-ad-dns-verification.png)

### Hyper-V Checkpoint after AD DS and DNS

![Hyper-V AD DS DNS Checkpoint](../../diagrams/windows-server/05-hyperv-dc-vm-checkpoint.png)

### Domain Controller Network Configuration

![Domain Controller Network Configuration](../../diagrams/windows-server/06-dc-vm-network-config.png)

### Server Manager with DHCP

![Server Manager DHCP](../../diagrams/windows-server/07-server-manager-dhcp.png)

### DHCP Address Pool

![DHCP Address Pool](../../diagrams/windows-server/08-dhcp-addresses-pool.png)

### DHCP Scope Options

![DHCP Scope Options](../../diagrams/windows-server/09-dhcp-scope-options.png)

### DHCP PowerShell Verification

![DHCP PowerShell Verification](../../diagrams/windows-server/10-dhcp-powershell-verification.png)

### Hyper-V Checkpoint after DHCP

![Hyper-V DHCP Checkpoint](../../diagrams/windows-server/11-hyperv-dhcp-checkpoint.png)

### Windows Client DHCP Configuration

![Windows Client DHCP Configuration](../../diagrams/windows-server/12-client-dhcp-ipconfig.png)

### Windows Client Domain Verification

![Windows Client Domain Verification](../../diagrams/windows-server/13-client-domain-verification.png)

### Domain User Logon

![Domain User Logon](../../diagrams/windows-server/14-client-domain-user-login.png)

### Active Directory Computer Object

![Active Directory Computer Object](../../diagrams/windows-server/15-ad-computer-object.png)

### DHCP Active Lease

![DHCP Active Lease](../../diagrams/windows-server/16-dhcp-active-lease.png)

### Organizational Unit Structure

![Organizational Unit Structure](../../diagrams/windows-server/17-ou-structure.png)

### AD Users

![AD Users](../../diagrams/windows-server/18-ad-users.png)

### AD Groups

![AD Groups](../../diagrams/windows-server/19-ad-groups.png)

### Workstation Computer OU

![Workstation Computer OU](../../diagrams/windows-server/20-workstation-computer-ou.png)

### GPO Linked to Workstations OU

![GPO Linked to Workstations OU](../../diagrams/windows-server/21-gpo-linked-workstations.png)

### GPO Linked to Users OU

![GPO Linked to Users OU](../../diagrams/windows-server/22-gpo-linked-users.png)

### User GPO Result

![User GPO Result](../../diagrams/windows-server/23-gpresult-user-gpo.png)

### Legal Notice from GPO

![Legal Notice from GPO](../../diagrams/windows-server/23-legal-notice-login.png)

### Computer GPO Result

![Computer GPO Result](../../diagrams/windows-server/24-gpresult-computer-gpo.png)

### SMB Share Created

![SMB Share Created](../../diagrams/windows-server/25-smb-share-created.png)

### SMB Share and NTFS Permissions

![SMB Share Permissions](../../diagrams/windows-server/26-smb-share-permissions.png)

### Drive Mapping GPO

![Drive Mapping GPO](../../diagrams/windows-server/27-drive-mapping-gpo.png)

### Drive Mapping GPO Result

![Drive Mapping GPO Result](../../diagrams/windows-server/28-gpresult-drive-mapping.png)

### Mapped Drive with net use

![Mapped Drive net use](../../diagrams/windows-server/29-mapped-drive-net-use.png)

### Mapped Drive in File Explorer

![Mapped Drive Explorer](../../diagrams/windows-server/30-mapped-drive-explorer.png)

### File Share Write Test

![File Share Write Test](../../diagrams/windows-server/31-file-share-write-test.png)

---


### Storage VM in Servers OU

![Storage VM in Servers OU](../../diagrams/windows-server/32-storage-vm-server-ou.png)

### iSCSI Target Server Role Installed

![iSCSI Target Server Role Installed](../../diagrams/windows-server/33-iscsi-role-installed.png)

### iSCSI Virtual Disk

![iSCSI Virtual Disk](../../diagrams/windows-server/34-iscsi-virtual-disk.png)

### iSCSI Target Created

![iSCSI Target Created](../../diagrams/windows-server/35-iscsi-target-created.png)

### iSCSI Target Connected

![iSCSI Target Connected](../../diagrams/windows-server/36-iscsi-target-connected.png)

### Client iSCSI Portal and Target

![Client iSCSI Portal and Target](../../diagrams/windows-server/37-client-iscsi-portal-target.png)

### Client iSCSI Session

![Client iSCSI Session](../../diagrams/windows-server/38-client-iscsi-session.png)

### Client iSCSI Disk and Volume

![Client iSCSI Disk and Volume](../../diagrams/windows-server/39-client-iscsi-disk-volume.png)

### iSCSI Write Test

![iSCSI Write Test](../../diagrams/windows-server/40-iscsi-write-test.png)


## Notes

The DNS client on the domain controller may show loopback addresses such as `127.0.0.1` or `::1`. This is expected for a domain controller because the DNS service runs locally on the same server.

The DHCP scope does not include a router/default gateway option yet. This is intentional because the lab network is currently isolated through an internal Hyper-V switch.

The file share is hosted on the domain controller for lab purposes. In a production environment, a dedicated file server would normally be preferred.

The iSCSI storage configuration is a lab simulation of block storage. In a production environment, iSCSI targets are usually provided by dedicated storage arrays, SAN devices or dedicated storage servers.

The domain user `testuser01` was added to the local `Remote Desktop Users` group on the Windows client VM to allow logon through the Hyper-V/VMConnect remote session mechanism.

A legacy `Lab Users` OU may remain from the earlier user-creation step. Active users for the final structure are placed under:

```text
OU=Users,OU=Enterprise Lab,DC=enterprise,DC=lab
```

---

## Next Steps

Planned next steps for the Windows Server module:

- Add Veeam Backup & Replication Community Edition
- Create a backup repository
- Create a backup job
- Run backup and restore verification
- Document RPO/RTO basics and restore test results

---

## Veeam Backup & Restore Module

### Goal

This module adds Veeam Backup & Replication Community Edition to the Enterprise Infrastructure Lab and verifies a complete backup and restore workflow.

The purpose is to demonstrate:

- Veeam Backup & Replication installation on a dedicated backup server
- iSCSI-backed backup repository configuration
- SMB file share protection
- successful backup job execution
- file-level restore from backup
- post-restore verification

### Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | AD DS, DNS, DHCP, GPO, SMB file share |
| storage-vm | 10.10.10.20 | iSCSI Target Server |
| backup-vm | 10.10.10.30 | Veeam Backup & Replication Community Edition |
| win-client-vm | 10.10.10.100 | Domain client and iSCSI initiator test client |

### Veeam Configuration

```text
Backup server: backup-vm.enterprise.lab
Backup server IP: 10.10.10.30
Veeam edition: Community Edition
Repository volume: R:
Repository volume label: VEEAM-REPO
Repository path used by Veeam: R:\Backups
Repository type: Microsoft Windows backup repository
Repository backing storage: iSCSI LUN from storage-vm
iSCSI target: veeam-repo-target
iSCSI virtual disk: E:\iSCSI\VeeamRepo01.vhdx
Repository LUN size: 20 GB
Backup source: \\dc-vm\LabShare
Backup job: Backup LabShare to iSCSI Repository
Job type: File Backup
Schedule: Manual / not scheduled
```

### Backup Flow

```text
\\dc-vm\LabShare
        ↓
Veeam file backup job on backup-vm
        ↓
iSCSI-backed Veeam repository
R:\Backups
        ↓
File-level restore verification
```

### Restore Test

A test file was deleted from the source SMB share and restored from the Veeam backup.

```text
Deleted file: \\dc-vm\LabShare\veeam-source-test.txt
Restore source: Veeam backup restore point
Restore destination: original location
Restore result: completed successfully
Verification: file appeared again in \\dc-vm\LabShare and content was readable
```

### Verification Commands

```powershell
Get-Volume
Get-IscsiSession
dir R:\
dir R:\Backups
dir R:\Backups -Recurse
Test-Path "\\dc-vm\LabShare"
dir "\\dc-vm\LabShare"
type "\\dc-vm\LabShare\veeam-source-test.txt"
```

Expected result:

```text
R: volume exists
R: is labeled VEEAM-REPO
iSCSI session is active and persistent
Veeam backup files exist under R:\Backups
\\dc-vm\LabShare is reachable
veeam-source-test.txt was restored successfully
file content is readable
```

### Veeam Screenshots

#### Veeam Console Home

![Veeam Console Home](../../diagrams/windows-server/41-veeam-console-home.png)

#### iSCSI Veeam Repository

![iSCSI Veeam Repository](../../diagrams/windows-server/42-veeam-iscsi-repository.png)

#### Repository Volume and iSCSI Session

![Repository Volume and iSCSI Session](../../diagrams/windows-server/43-veeam-repository-volume.png)

#### SMB File Share Source

![SMB File Share Source](../../diagrams/windows-server/44-veeam-smb-file-share-source.png)

#### File Share Backup Job

![File Share Backup Job](../../diagrams/windows-server/45-veeam-file-share-backup-job.png)

#### Repository Backup Files

![Repository Backup Files](../../diagrams/windows-server/46-veeam-repository-files.png)

#### Source File Deleted

![Source File Deleted](../../diagrams/windows-server/49-veeam-source-file-deleted.png)

#### File Restore Browser

![File Restore Browser](../../diagrams/windows-server/50-veeam-file-restore-browser.png)

#### Restored File Verification

![Restored File Verification](../../diagrams/windows-server/51-veeam-file-restore-success.png)

#### Restore Completed Successfully

![Restore Completed Successfully](../../diagrams/windows-server/52-veeam-restore-completed-successfully.png)

#### Restore History

![Restore History](../../diagrams/windows-server/53-veeam-restore-history.png)

### Lab Notes

The Veeam repository size is intentionally small because this lab runs on a laptop. The goal is to demonstrate repository configuration, backup job execution and restore validation, not production-scale backup capacity planning.

The repository path is `R:\Backups`. The folder `R:\VeeamRepo` was used earlier as an initial storage write test and is not the active Veeam repository path.
