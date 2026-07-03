# Windows Server Active Directory, DNS and DHCP Module

## Goal

This module adds a Windows Server infrastructure component to the Enterprise Infrastructure Lab.

The goal is to practice common enterprise infrastructure administration tasks with Windows Server 2022, Active Directory Domain Services, DNS, DHCP, domain controller configuration, static network configuration and operational verification.

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, Active Directory Domain Services, DNS, DHCP |

This module runs on a separate Hyper-V internal network:

```text
Hyper-V switch: EnterpriseLabNet
Network: 10.10.10.0/24
Domain Controller IP: 10.10.10.10
```

---

## Domain Configuration

```text
Domain: enterprise.lab
NetBIOS name: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
Domain Controller IP: 10.10.10.10
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

The DHCP server is authorized in Active Directory and provides IP configuration for future domain clients in the lab network.

No default gateway option is configured yet because the current `EnterpriseLabNet` switch is an internal Hyper-V network. Gateway/NAT configuration can be added later if internet access is required for domain clients.

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

---

## Notes

The DNS client on the domain controller may show loopback addresses such as `127.0.0.1` or `::1`. This is expected for a domain controller because the DNS service runs locally on the same server.

The important verification point is that the domain and domain controller records resolve correctly:

```text
enterprise.lab -> 10.10.10.10
dc-vm.enterprise.lab -> 10.10.10.10
```

The DHCP scope does not include a router/default gateway option yet. This is intentional because the lab network is currently isolated through an internal Hyper-V switch.

---

## Next Steps

Planned next steps for the Windows Server module:

- Create Organizational Units
- Create test users and groups
- Add a Windows client VM
- Configure the Windows client to receive an IP address from DHCP
- Join the Windows client to the `enterprise.lab` domain
- Apply basic Group Policy Objects
- Document domain client verification and GPO results
