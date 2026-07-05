# Runbook - iSCSI Troubleshooting

## 1. Check target service on storage-vm

```powershell
Get-Service WinTarget
```

If stopped:

```powershell
Start-Service WinTarget
Set-Service WinTarget -StartupType Automatic
```

## 2. Check port 3260

From initiator VM:

```powershell
Test-NetConnection 10.10.10.20 -Port 3260
```

Expected:

```text
TcpTestSucceeded : True
```

## 3. Check firewall on storage-vm

```powershell
New-NetFirewallRule `
  -DisplayName "Allow iSCSI Target TCP 3260" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 3260 `
  -Action Allow `
  -Profile Any
```

## 4. Check target configuration

```powershell
Get-IscsiVirtualDisk | Format-List Path,Size
Get-IscsiServerTarget | Format-List TargetName,InitiatorIds,Status
```

## 5. Check initiator session

```powershell
Get-IscsiTargetPortal
Get-IscsiTarget
Get-IscsiSession
Get-Disk
Get-Volume
```
