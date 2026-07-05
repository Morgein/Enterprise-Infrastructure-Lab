# 02 - Domain Client, OU, GPO and SMB Share

## Goal

Join a Windows client to the domain, organize AD objects, configure GPOs, create an SMB file share and deploy a mapped network drive.

## Configuration

```text
Domain client: win-client-vm
Client IP: 10.10.10.100
Domain user: testuser01@enterprise.lab
SMB share: \\dc-vm\LabShare
Mapped drive: Z:
```

## OU Structure

```text
enterprise.lab
└── Enterprise Lab
    ├── Groups
    ├── Servers
    ├── Service Accounts
    ├── Users
    └── Workstations
```

## Security Groups

```text
GG-IT-Admins
GG-Helpdesk
GG-Workstation-Users
```

## GPOs

| GPO | Linked OU | Purpose |
|---|---|---|
| Workstation Security Baseline | Workstations | Computer settings and legal notice |
| User Restrictions Baseline | Users | User-side restrictions |
| User Drive Mapping | Users | Maps `Z:` to `\\dc-vm\LabShare` |

## SMB Permissions

```text
Share: \\dc-vm\LabShare
Local path: C:\Shares\LabShare

Share permissions:
- ENTERPRISE\Domain Admins: Full
- ENTERPRISE\GG-Workstation-Users: Change

NTFS permissions:
- ENTERPRISE\Domain Admins: Full Control
- ENTERPRISE\GG-Workstation-Users: Modify
- SYSTEM: Full Control
```

## Verification Commands

```powershell
ipconfig /all
systeminfo | findstr /B /C:"Domain"
nltest /dsgetdc:enterprise.lab
gpupdate /force
gpresult /scope user /r
gpresult /scope computer /r
net use
dir Z:\
```

## Screenshots

![Client DHCP Configuration](../../diagrams/windows-server/12-client-dhcp-ipconfig.png)

![Client Domain Verification](../../diagrams/windows-server/13-client-domain-verification.png)

![Domain User Logon](../../diagrams/windows-server/14-client-domain-user-login.png)

![AD Computer Object](../../diagrams/windows-server/15-ad-computer-object.png)

![OU Structure](../../diagrams/windows-server/17-ou-structure.png)

![AD Users](../../diagrams/windows-server/18-ad-users.png)

![AD Groups](../../diagrams/windows-server/19-ad-groups.png)

![Workstation OU](../../diagrams/windows-server/20-workstation-computer-ou.png)

![GPO Workstations](../../diagrams/windows-server/21-gpo-linked-workstations.png)

![GPO Users](../../diagrams/windows-server/22-gpo-linked-users.png)

![User GPO Result](../../diagrams/windows-server/23-gpresult-user-gpo.png)

![Legal Notice](../../diagrams/windows-server/23-legal-notice-login.png)

![Computer GPO Result](../../diagrams/windows-server/24-gpresult-computer-gpo.png)

![SMB Share Created](../../diagrams/windows-server/25-smb-share-created.png)

![SMB Permissions](../../diagrams/windows-server/26-smb-share-permissions.png)

![Drive Mapping GPO](../../diagrams/windows-server/27-drive-mapping-gpo.png)

![Drive Mapping Result](../../diagrams/windows-server/28-gpresult-drive-mapping.png)

![Mapped Drive Net Use](../../diagrams/windows-server/29-mapped-drive-net-use.png)

![Mapped Drive Explorer](../../diagrams/windows-server/30-mapped-drive-explorer.png)

![File Share Write Test](../../diagrams/windows-server/31-file-share-write-test.png)
