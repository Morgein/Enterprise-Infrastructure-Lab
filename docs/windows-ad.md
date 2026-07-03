# Windows Server Active Directory Module

## Goal

This module adds a basic Windows Server domain environment to the Enterprise Infrastructure Lab.

The goal is to practice common infrastructure administration tasks with Active Directory Domain Services, DNS, domain controller configuration, static network configuration and operational verification.

---

## Architecture

| VM | IP Address | Role |
|---|---:|---|
| dc-vm | 10.10.10.10 | Windows Server 2022, Active Directory Domain Services, DNS |

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
- Hyper-V checkpoint after successful AD DS and DNS configuration

---

## Verification Commands

The following commands were used to verify the configuration:

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

---

## Screenshots

### Server Manager Roles

![Server Manager AD DS and DNS](../diagrams/windows-server/01-server-manager-ad-dns.png)

### Active Directory Domain

![Active Directory Domain](../diagrams/windows-server/02-active-directory-domain.png)

### DNS Forward Lookup Zone

![DNS Forward Lookup Zone](../diagrams/windows-server/03-dns-forward-zone.png)

### PowerShell AD and DNS Verification

![PowerShell AD DNS Verification](../diagrams/windows-server/04-powershell-ad-dns-verification.png)

### Hyper-V Checkpoint

![Hyper-V Checkpoint](../diagrams/windows-server/05-hyperv-dc-vm-checkpoint.png)

### Domain Controller Network Configuration

![Domain Controller Network Configuration](../diagrams/windows-server/06-dc-vm-network-config.png)

---

## Notes

The DNS client on the domain controller may show loopback addresses such as `127.0.0.1` or `::1`. This is normal for a domain controller because the DNS service runs locally on the same server.

The important verification point is that the domain and the domain controller records resolve correctly:

```text
enterprise.lab -> 10.10.10.10
dc-vm.enterprise.lab -> 10.10.10.10
```

---

## Next Steps

Planned next steps for the Windows Server module:

- Add DHCP Server role
- Configure DHCP scope for the lab network
- Create Organizational Units
- Create test users and groups
- Add a Windows client VM
- Join the Windows client to the domain
- Apply basic Group Policy Objects
