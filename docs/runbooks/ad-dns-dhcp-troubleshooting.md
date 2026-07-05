# Runbook - AD, DNS and DHCP Troubleshooting

## 1. Check domain controller services

```powershell
Get-Service DNS,NTDS,DHCPServer
```

Expected:

```text
DNS       Running
NTDS      Running
DHCPServer Running
```

## 2. Check domain health

```powershell
Get-ADDomain
nltest /dsgetdc:enterprise.lab
```

## 3. Check DNS resolution

```powershell
nslookup enterprise.lab
nslookup dc-vm.enterprise.lab
nslookup storage-vm.enterprise.lab
```

## 4. Check DHCP

```powershell
Get-DhcpServerInDC
Get-DhcpServerv4Scope
Get-DhcpServerv4Lease -ScopeId 10.10.10.0
```

## 5. Client-side checks

```powershell
ipconfig /all
ping 10.10.10.10
nslookup enterprise.lab
```

## Common Fixes

Restart DHCP:

```powershell
Restart-Service DHCPServer
```

Update DNS client settings:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.10.10.10
```
