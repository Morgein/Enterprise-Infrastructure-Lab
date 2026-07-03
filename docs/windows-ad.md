# Windows Server Active Directory, DNS, DHCP and Domain Client Module

## Goal

This module adds a Windows Server infrastructure component to the Enterprise Infrastructure Lab.

The goal is to practice common enterprise infrastructure administration tasks with Windows Server 2022, Active Directory Domain Services, DNS, DHCP, domain controller configuration, domain user management, Windows client domain join and operational verification.

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, Active Directory Domain Services, DNS, DHCP |
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
- Organizational Unit for lab users
- Domain user `testuser01`
- Windows client VM `win-client-vm`
- DHCP lease issued to the Windows client
- Windows client joined to the `enterprise.lab` domain
- Successful domain logon as `ENTERPRISE\testuser01`
- Hyper-V checkpoints after successful AD DS, DNS and DHCP configuration

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
OU: Lab Users
```

The Windows client VM was configured with DHCP and joined to the domain:

```text
Client hostname: win-client-vm
Client IP: 10.10.10.100
DHCP Server: 10.10.10.10
DNS Server: 10.10.10.10
DNS suffix: enterprise.lab
Domain: enterprise.lab
```

The client successfully authenticated as:

```text
enterprise\testuser01
```

The computer object appeared in Active Directory under the default `Computers` container.

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

Expected results:

```text
whoami: enterprise\administrator
DNSRoot: enterprise.lab
NetBIOSName: ENTERPRISE
PDCEmulator: dc-vm.enterprise.lab
DNS service: Running
NTDS service: Running
enterprise.lab resolves to 10.10.10.10
dc-vm.enterprise.lab resolves to 10.10.10.10
```

### DHCP verification

```powershell
Get-Service DHCPServer | Select-Object Status,Name,DisplayName

Get-DhcpServerInDC | Select-Object DnsName,IPAddress

Get-DhcpServerv4Scope | Select-Object ScopeId,Name,StartRange,EndRange,State

Get-DhcpServerv4OptionValue -ScopeId 10.10.10.0 | Select-Object OptionId,Name,Value

Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

Expected results:

```text
DHCPServer: Running
Authorized DHCP server: dc-vm.enterprise.lab / 10.10.10.10
ScopeId: 10.10.10.0
Scope name: EnterpriseLab Scope
StartRange: 10.10.10.100
EndRange: 10.10.10.200
State: Active
DNS Servers: 10.10.10.10
DNS Domain Name: enterprise.lab
Active lease: win-client-vm / 10.10.10.100
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

Expected results:

```text
Host Name: win-client-vm
Primary DNS Suffix: enterprise.lab
IPv4 Address: 10.10.10.100
DHCP Server: 10.10.10.10
DNS Servers: 10.10.10.10
Domain: enterprise.lab
Domain Controller: dc-vm.enterprise.lab
Logged-in user: enterprise\testuser01
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

---

## Notes

The DNS client on the domain controller may show loopback addresses such as `127.0.0.1` or `::1`. This is expected for a domain controller because the DNS service runs locally on the same server.

The important verification point is that the domain and domain controller records resolve correctly:

```text
enterprise.lab -> 10.10.10.10
dc-vm.enterprise.lab -> 10.10.10.10
```

The DHCP scope does not include a router/default gateway option yet. This is intentional because the lab network is currently isolated through an internal Hyper-V switch.

The domain user `testuser01` was added to the local `Remote Desktop Users` group on the Windows client VM to allow logon through the Hyper-V/VMConnect remote session mechanism.

---

## Next Steps

Planned next steps for the Windows Server module:

- Create a cleaner Organizational Unit structure for users, groups, servers and workstations
- Move the Windows client computer object from the default `Computers` container to a dedicated workstation OU
- Create security groups for administration and helpdesk scenarios
- Configure basic Group Policy Objects
- Document GPO application and verification with `gpupdate` and `gpresult`
