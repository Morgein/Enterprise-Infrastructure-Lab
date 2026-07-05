# 01 - Active Directory, DNS and DHCP

## Goal

Deploy the base Windows Server domain services for the enterprise lab.

## Configuration

```text
Domain: enterprise.lab
NetBIOS: ENTERPRISE
Domain Controller: dc-vm.enterprise.lab
Domain Controller IP: 10.10.10.10
DNS Server: 10.10.10.10
DHCP Server: dc-vm.enterprise.lab
DHCP Scope: 10.10.10.100 - 10.10.10.200
```

## Implemented

- Windows Server 2022 as domain controller
- New AD forest: `enterprise.lab`
- AD-integrated DNS zone
- DHCP role installed and authorized
- DHCP scope configured for the lab network
- DNS and DHCP verification performed

## Verification Commands

```powershell
Get-ADDomain | Select-Object DNSRoot,NetBIOSName,PDCEmulator
Get-Service DNS,NTDS
nslookup enterprise.lab
nslookup dc-vm.enterprise.lab

Get-Service DHCPServer
Get-DhcpServerInDC
Get-DhcpServerv4Scope
Get-DhcpServerv4OptionValue -ScopeId 10.10.10.0
Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

## Screenshots

![Server Manager AD DS and DNS](../../diagrams/windows-server/01-server-manager-ad-dns.png)

![Active Directory Domain](../../diagrams/windows-server/02-active-directory-domain.png)

![DNS Forward Lookup Zone](../../diagrams/windows-server/03-dns-forward-zone.png)

![PowerShell AD DNS Verification](../../diagrams/windows-server/04-powershell-ad-dns-verification.png)

![Domain Controller Network Configuration](../../diagrams/windows-server/06-dc-vm-network-config.png)

![Server Manager DHCP](../../diagrams/windows-server/07-server-manager-dhcp.png)

![DHCP Address Pool](../../diagrams/windows-server/08-dhcp-addresses-pool.png)

![DHCP Scope Options](../../diagrams/windows-server/09-dhcp-scope-options.png)

![DHCP PowerShell Verification](../../diagrams/windows-server/10-dhcp-powershell-verification.png)

![DHCP Active Lease](../../diagrams/windows-server/16-dhcp-active-lease.png)
