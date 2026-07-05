# Windows Server Active Directory, DNS, DHCP, Domain Client and GPO Module

## Goal

This module adds a Windows Server infrastructure component to the Enterprise Infrastructure Lab.

The goal is to practice common enterprise infrastructure administration tasks with Windows Server 2022, Active Directory Domain Services, DNS, DHCP, domain controller configuration, domain user management, Windows client domain join, Organizational Units, security groups, Group Policy Objects and operational verification.

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, Active Directory Domain Services, DNS, DHCP, Group Policy Management |
| win-client-vm | 10.10.10.100 | Windows client joined to `enterprise.lab` |

This module runs on a separate Hyper-V internal network:

```text
Hyper-V switch: EnterpriseLabNet
Network: 10.10.10.0/24
Domain Controller IP: 10.10.10.10
Client IP: 10.10.10.100
```

---

## Domain Configuration

```text
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
Domain Controller IP: 10.10.10.10
Domain client: win-client-vm
Domain user: testuser01@enterprise.lab
Helpdesk user: helpdesk01@enterprise.lab
```

---

## Implemented Components

- Windows Server 2022 Standard Evaluation with Desktop Experience
- Static IPv4 configuration on the domain controller
- Active Directory Domain Services role
- DNS Server role
- New AD forest: `enterprise.lab`
- Domain controller: `dc-vm`
- AD-integrated DNS zone: `enterprise.lab`
- DNS A records for the domain and domain controller
- DHCP Server role
- DHCP authorization in Active Directory
- DHCP IPv4 scope for the lab network
- DHCP scope options for DNS server and DNS domain
- Windows client VM `win-client-vm`
- DHCP lease issued to the Windows client
- Windows client joined to the `enterprise.lab` domain
- Domain user `testuser01`
- Helpdesk user `helpdesk01`
- Organizational Unit structure for users, groups, servers, service accounts and workstations
- Security groups for IT/admin/helpdesk/workstation-user scenarios
- Windows client computer object moved to the `Workstations` OU
- User GPO linked to the `Users` OU
- Computer GPO linked to the `Workstations` OU
- Successful application of user and computer GPOs verified with `gpresult`
- Legal notice configured through Group Policy
- Successful domain logon as `ENTERPRISE\testuser01`

---

## Active Directory and DNS Configuration

The server was promoted to a domain controller for a new forest:

```text
Forest: enterprise.lab
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
```

DNS was installed together with Active Directory Domain Services. The `enterprise.lab` forward lookup zone was created and contains records for the domain and the domain controller.

Expected DNS resolution:

```text
enterprise.lab -> 10.10.10.10
dc-vm.enterprise.lab -> 10.10.10.10
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

The DHCP server is authorized in Active Directory and provides IP configuration for domain clients in the lab network.

No default gateway option is configured yet because the current `EnterpriseLabNet` switch is an internal Hyper-V network. Gateway/NAT configuration can be added later if internet access is required for domain clients.

---

## Domain User and Client Configuration

A test domain user was created for client logon verification:

```text
User: testuser01
UPN: testuser01@enterprise.lab
Domain logon: ENTERPRISE\testuser01
OU: Enterprise Lab / Users
```

A helpdesk user was also created:

```text
User: helpdesk01
UPN: helpdesk01@enterprise.lab
OU: Enterprise Lab / Users
Group: GG-Helpdesk
```

The Windows client VM was configured with DHCP and joined to the domain:

```text
Client hostname: win-client-vm
Client IP: 10.10.10.100
DHCP Server: 10.10.10.10
DNS Server: 10.10.10.10
DNS suffix: enterprise.lab
Domain: enterprise.lab
OU: Enterprise Lab / Workstations
```

The client successfully authenticated as:

```text
enterprise\testuser01
```

---

## Organizational Unit Structure

The following OU structure was created for the lab:

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

Two basic GPOs were created and linked to the appropriate OUs.

### Workstation Security Baseline

Linked to:

```text
OU=Workstations,OU=Enterprise Lab,DC=enterprise,DC=lab
```

Purpose:

```text
Computer-side workstation baseline policy.
```

Implemented settings include:

```text
- Legal notice before logon
- Windows Firewall baseline configuration
```

Verified on the client with:

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

Purpose:

```text
User-side restrictions for standard domain users.
```

Implemented settings include:

```text
- Prohibit access to Control Panel and PC settings
```

Verified on the client with:

```powershell
gpresult /scope user /r
```

Expected applied GPO:

```text
User Restrictions Baseline
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
Get-NetIPAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
Get-DnsClientServerAddress -InterfaceAlias "Ethernet"
```

### DHCP verification

```powershell
Get-Service DHCPServer | Select-Object Status,Name,DisplayName
Get-DhcpServerInDC | Select-Object DnsName,IPAddress
Get-DhcpServerv4Scope | Select-Object ScopeId,Name,StartRange,EndRange,State
Get-DhcpServerv4OptionValue -ScopeId 10.10.10.0 | Select-Object OptionId,Name,Value
Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

### Client domain verification

On the Windows client:

```powershell
ipconfig /all
hostname
systeminfo | findstr /B /C:"Domain"
nltest /dsgetdc:enterprise.lab
whoami
```

### OU and GPO verification

On the domain controller:

```powershell
Get-ADOrganizationalUnit -Filter * | Select-Object Name,DistinguishedName

Get-ADUser -Filter * -SearchBase "OU=Users,OU=Enterprise Lab,DC=enterprise,DC=lab" |
Select-Object Name,SamAccountName,Enabled

Get-ADGroup -Filter * -SearchBase "OU=Groups,OU=Enterprise Lab,DC=enterprise,DC=lab" |
Select-Object Name,GroupCategory,GroupScope

Get-ADComputer "WIN-CLIENT-VM" -Properties DistinguishedName |
Select-Object Name,DistinguishedName
```

On the Windows client:

```powershell
gpupdate /force
gpresult /scope user /r
gpresult /scope computer /r
```

Expected applied GPOs:

```text
User settings:
- User Restrictions Baseline

Computer settings:
- Workstation Security Baseline
- Default Domain Policy
```

---

## Screenshots

### Server Manager with AD DS and DNS

![Server Manager AD DS and DNS](../diagrams/windows-server/01-server-manager-ad-dns.png)

### Active Directory Domain

![Active Directory Domain](../diagrams/windows-server/02-active-directory-domain.png)

### DNS Forward Lookup Zone

![DNS Forward Lookup Zone](../diagrams/windows-server/03-dns-forward-zone.png)

### PowerShell AD and DNS Verification

![PowerShell AD DNS Verification](../diagrams/windows-server/04-powershell-ad-dns-verification.png)

### Hyper-V Checkpoint after AD DS and DNS

![Hyper-V AD DS DNS Checkpoint](../diagrams/windows-server/05-hyperv-dc-vm-checkpoint.png)

### Domain Controller Network Configuration

![Domain Controller Network Configuration](../diagrams/windows-server/06-dc-vm-network-config.png)

### Server Manager with DHCP

![Server Manager DHCP](../diagrams/windows-server/07-server-manager-dhcp.png)

### DHCP Address Pool

![DHCP Address Pool](../diagrams/windows-server/08-dhcp-addresses-pool.png)

### DHCP Scope Options

![DHCP Scope Options](../diagrams/windows-server/09-dhcp-scope-options.png)

### DHCP PowerShell Verification

![DHCP PowerShell Verification](../diagrams/windows-server/10-dhcp-powershell-verification.png)

### Hyper-V Checkpoint after DHCP

![Hyper-V DHCP Checkpoint](../diagrams/windows-server/11-hyperv-dhcp-checkpoint.png)

### Windows Client DHCP Configuration

![Windows Client DHCP Configuration](../diagrams/windows-server/12-client-dhcp-ipconfig.png)

### Windows Client Domain Verification

![Windows Client Domain Verification](../diagrams/windows-server/13-client-domain-verification.png)

### Domain User Logon

![Domain User Logon](../diagrams/windows-server/14-client-domain-user-login.png)

### Active Directory Computer Object

![Active Directory Computer Object](../diagrams/windows-server/15-ad-computer-object.png)

### DHCP Active Lease

![DHCP Active Lease](../diagrams/windows-server/16-dhcp-active-lease.png)

### Organizational Unit Structure

![Organizational Unit Structure](../diagrams/windows-server/17-ou-structure.png)

### AD Users

![AD Users](../diagrams/windows-server/18-ad-users.png)

### AD Groups

![AD Groups](../diagrams/windows-server/19-ad-groups.png)

### Workstation Computer OU

![Workstation Computer OU](../diagrams/windows-server/20-workstation-computer-ou.png)

### GPO Linked to Workstations OU

![GPO Linked to Workstations OU](../diagrams/windows-server/21-gpo-linked-workstations.png)

### GPO Linked to Users OU

![GPO Linked to Users OU](../diagrams/windows-server/22-gpo-linked-users.png)

### User GPO Result

![User GPO Result](../diagrams/windows-server/23-gpresult-user-gpo.png)

### Legal Notice from GPO

![Legal Notice from GPO](../diagrams/windows-server/23-legal-notice-login.png)

### Computer GPO Result

![Computer GPO Result](../diagrams/windows-server/24-gpresult-computer-gpo.png)

---

## Notes

The DNS client on the domain controller may show loopback addresses such as `127.0.0.1` or `::1`. This is expected for a domain controller because the DNS service runs locally on the same server.

The DHCP scope does not include a router/default gateway option yet. This is intentional because the lab network is currently isolated through an internal Hyper-V switch.

The domain user `testuser01` was added to the local `Remote Desktop Users` group on the Windows client VM to allow logon through the Hyper-V/VMConnect remote session mechanism.

A legacy `Lab Users` OU may remain from the earlier user-creation step. Active users for the final structure are placed under:

```text
OU=Users,OU=Enterprise Lab,DC=enterprise,DC=lab
```

---

## Next Steps

Planned next steps for the Windows Server module:

- Create a small file share for domain users
- Map the file share through Group Policy
- Add a helpdesk-style local administrator policy for selected users
- Add DNS records for lab services such as Grafana and API
- Document troubleshooting runbooks for domain logon, DNS, DHCP and GPO issues
